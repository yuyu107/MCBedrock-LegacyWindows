using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;

public static class Win81ApiSetLauncherV16
{
    const uint CREATE_SUSPENDED = 0x00000004;
    const uint DEBUG_ONLY_THIS_PROCESS = 0x00000002;
    const uint MEM_COMMIT = 0x1000, MEM_RESERVE = 0x2000;
    const uint PAGE_READWRITE = 0x04;

    [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
    struct STARTUPINFO {
        public Int32 cb; public string lpReserved; public string lpDesktop; public string lpTitle;
        public Int32 dwX,dwY,dwXSize,dwYSize,dwXCountChars,dwYCountChars,dwFillAttribute,dwFlags;
        public Int16 wShowWindow,cbReserved2; public IntPtr lpReserved2,hStdInput,hStdOutput,hStdError;
    }
    [StructLayout(LayoutKind.Sequential)] struct PROCESS_INFORMATION { public IntPtr hProcess,hThread; public UInt32 dwProcessId,dwThreadId; }
    [StructLayout(LayoutKind.Sequential)] struct PROCESS_BASIC_INFORMATION { public IntPtr Reserved1,PebBaseAddress,Reserved2_0,Reserved2_1,UniqueProcessId,Reserved3; }

    [DllImport("kernel32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
    static extern bool CreateProcessW(string app,string cmd,IntPtr pa,IntPtr ta,bool inherit,uint flags,IntPtr env,string cwd,ref STARTUPINFO si,out PROCESS_INFORMATION pi);
    [DllImport("kernel32.dll", SetLastError=true)] static extern bool ReadProcessMemory(IntPtr hp,IntPtr addr,byte[] buf,IntPtr size,out IntPtr read);
    [DllImport("kernel32.dll", SetLastError=true)] static extern bool WriteProcessMemory(IntPtr hp,IntPtr addr,byte[] buf,IntPtr size,out IntPtr written);
    [DllImport("kernel32.dll", SetLastError=true)] static extern IntPtr VirtualAllocEx(IntPtr hp,IntPtr addr,UIntPtr size,uint type,uint protect);
    [DllImport("kernel32.dll", SetLastError=true)] static extern uint ResumeThread(IntPtr ht);
    [DllImport("kernel32.dll", SetLastError=true)] static extern uint WaitForSingleObject(IntPtr h,uint ms);
    [DllImport("kernel32.dll", SetLastError=true)] static extern bool GetExitCodeProcess(IntPtr hp,out uint code);
    [DllImport("kernel32.dll", SetLastError=true)] static extern bool TerminateProcess(IntPtr hp,uint code);
    [DllImport("kernel32.dll", SetLastError=true)] static extern bool CloseHandle(IntPtr h);
    [DllImport("kernel32.dll", SetLastError=true)] static extern bool DebugActiveProcessStop(uint pid);
    [DllImport("ntdll.dll")] static extern int NtQueryInformationProcess(IntPtr hp,int cls,ref PROCESS_BASIC_INFORMATION pbi,int len,out int retlen);

    class Target { public string Name,Host; public Target(string n,string h){Name=n;Host=h;} }
    class ValueRec { public uint Flags; public string Name=""; public string Host=""; }
    class EntryRec { public uint Flags; public string Name=""; public string Alias=""; public uint ValueFlags; public List<ValueRec> Values=new List<ValueRec>(); }

    // Same compatibility target set used by the verified Windows 8.1 Launcher Login Bridge.
    static readonly Target[] Targets = new Target[] {
        new Target("ms-win-core-libraryloader-l1-2-0","kernel32.dll"),
        new Target("ms-win-core-registry-l1-1-0","advapi32.dll"),
        new Target("ms-win-core-psapi-l1-1-0","kernel32.dll"),
        new Target("ms-win-core-kernel32-legacy-l1-1-2","kernel32.dll"),
        new Target("ms-win-core-synch-l1-2-1","kernel32.dll"),
        new Target("ms-win-core-heap-obsolete-l1-1-0","kernel32.dll"),
        new Target("ms-win-core-heap-l2-1-0","kernel32.dll"),
        new Target("ms-win-ntuser-sysparams-l1-1-0","user32.dll"),
        new Target("ms-win-core-libraryloader-l1-2-1","kernel32.dll"),
        new Target("ms-win-shcore-obsolete-l1-1-0","shell32.dll"),
        new Target("ms-win-core-sysinfo-l1-2-0","kernel32.dll"),
        new Target("ms-win-core-string-obsolete-l1-1-0","kernel32.dll"),
        new Target("ms-win-security-cryptoapi-l1-1-0","advapi32.dll"),
        new Target("ms-win-core-kernel32-legacy-l1-1-0","kernel32.dll"),
        new Target("ms-win-core-io-l1-1-0","kernel32.dll"),
        new Target("ms-win-core-synch-ansi-l1-1-0","kernel32.dll"),
        new Target("ms-win-core-file-l1-2-2","kernel32.dll")
    };

    public static void ValidateTarget(string path) {
        using(var fs=new FileStream(path,FileMode.Open,FileAccess.Read,FileShare.Read))
        using(var br=new BinaryReader(fs)) {
            if(fs.Length<0x100 || br.ReadUInt16()!=0x5A4D) throw new Exception("Target is not an MZ executable.");
            fs.Position=0x3C; int pe=br.ReadInt32();
            if(pe<0x40 || pe>fs.Length-0x100) throw new Exception("Invalid PE header.");
            fs.Position=pe; if(br.ReadUInt32()!=0x4550) throw new Exception("Invalid PE signature.");
            if(br.ReadUInt16()!=0x8664) throw new Exception("Minecraft.Windows.exe must be x64.");
            fs.Position=pe+24; if(br.ReadUInt16()!=0x20B) throw new Exception("Minecraft.Windows.exe must be PE32+.");
        }
    }

    static uint U32(byte[] b,int o){return BitConverter.ToUInt32(b,o);}
    static string US(byte[] b,uint off,uint len){
        if(len==0) return "";
        if((ulong)off+len>(ulong)b.Length) throw new Exception("ApiSet string out of range.");
        return Encoding.Unicode.GetString(b,(int)off,(int)len);
    }
    static byte[] RPM(IntPtr hp,IntPtr a,int n){
        byte[] b=new byte[n]; IntPtr r;
        if(!ReadProcessMemory(hp,a,b,(IntPtr)n,out r) || r.ToInt64()!=n)
            throw new Exception("ReadProcessMemory failed: "+Marshal.GetLastWin32Error());
        return b;
    }
    static void WPM(IntPtr hp,IntPtr a,byte[] b){
        IntPtr w;
        if(!WriteProcessMemory(hp,a,b,(IntPtr)b.Length,out w) || w.ToInt64()!=b.Length)
            throw new Exception("WriteProcessMemory failed: "+Marshal.GetLastWin32Error());
    }
    static EntryRec Find(List<EntryRec> list,string name) {
        foreach(EntryRec e in list)
            if(String.Equals(e.Name,name,StringComparison.OrdinalIgnoreCase)) return e;
        return null;
    }

    static List<EntryRec> ParseMap(byte[] map,out uint schemaFlags) {
        if(map.Length<16 || U32(map,0)!=4) throw new Exception("Target ApiSet schema is not v4 (Windows 8.1).");
        uint size=U32(map,4), count=U32(map,12); schemaFlags=U32(map,8);
        if(size>map.Length || size<16) throw new Exception("Invalid v4 schema size.");
        if(16UL+(ulong)count*24UL>(ulong)map.Length) throw new Exception("Invalid v4 namespace array.");
        List<EntryRec> list=new List<EntryRec>();
        for(int i=0;i<(int)count;i++) {
            int o=16+i*24;
            EntryRec e=new EntryRec();
            e.Flags=U32(map,o);
            uint no=U32(map,o+4), nl=U32(map,o+8), ao=U32(map,o+12), al=U32(map,o+16), data=U32(map,o+20);
            e.Name=US(map,no,nl); e.Alias=US(map,ao,al);
            if(data!=0) {
                if((ulong)data+8>(ulong)map.Length) throw new Exception("Value array out of range for "+e.Name);
                e.ValueFlags=U32(map,(int)data); uint vc=U32(map,(int)data+4);
                if((ulong)data+8UL+(ulong)vc*20UL>(ulong)map.Length) throw new Exception("Value entries out of range for "+e.Name);
                for(int j=0;j<(int)vc;j++) {
                    int vo=(int)data+8+j*20; ValueRec v=new ValueRec(); v.Flags=U32(map,vo);
                    uint vno=U32(map,vo+4), vnl=U32(map,vo+8), vho=U32(map,vo+12), vhl=U32(map,vo+16);
                    v.Name=US(map,vno,vnl); v.Host=US(map,vho,vhl); e.Values.Add(v);
                }
            }
            list.Add(e);
        }
        return list;
    }

    static bool HasDefaultHost(EntryRec e,out string host) {
        host=""; if(e.Values.Count==0) return false;
        ValueRec v=e.Values[0];
        if(v.Host==null || v.Host.Length==0) return false;
        host=v.Host; return true;
    }
    static void SetDefaultHost(EntryRec e,string host) {
        if(e.Values.Count>0 && (ename==null || e.Values[0].Name.Length==0)) {
            e.Values[0].Name=""; e.Values[0].Host=host;
      } else {
            ValueRec v=new ValueRec(); v.Flags=0; v.Name=""; v.Host=host; e.Values.Insert(0,v);
      }
    }

    static int AppendBytes(List<byte> b,byte[] x) { int o-b.Count; b.AddRange(x); return o; }
    static void Align4(List<byte> b){ while((b.Count&3)!=0)b.Add(0); }
    static int AppendUnicode(List<byte> b,string s) { if(String.IsNullOrEmpty(s)) return 0; return AppendBytes(b,Encoding.Unicode.GetBytes(s)); }
    static void PatchU32(List<byte> b,int off,uint v){ byte[] x=BitConverter.GetBytes(v); for(int i=0;i<4;i++)eoff+i]=x[i]; }

    static byte[] SerializeMap(List<EntryRec> entries,uint schemaFlags) {
        entries.Sort(delegate(EntryRec left,EntryRec right){return StringComparer.OrdinalIgnoreCase.Compare(left.Name,right.Name);});
        for(int i=1;i<entries.Count;i++) if(StringComparer.OrdinalIgnoreCase.Compare(entries[i-1].Name,entries[i].Name)>=0) throw new Exception("Duplicate or unsorted ApiSet namespace name: "+entries[i].Name);

        int fixedLen=16+entries.Count*24;
        List<byte> b=new List<byte>(fixedLen+65536);
        for(int i=0;i<fixedLen;i++) b.Add(0);
        PatchU32(b,0,4); PatchU32(b,8,schemaFlags); PatchU32(b,12,(uint)entries.Count);

        for(int i=0;i<entries.Count;i++) {
            EntryRec e=entries[i]; int eo=16+i*24;
            int nameOff=AppendUnicode(b,e.Name); int nameLen=Encoding.Unicode.GetByteCount(e.Name);
            int aliasOff=AppendUnicode(b,e.Alias); int aliasLen=Encoding.Unicode.GetByteCount(e.Alias);
            Align4(b); int dataOff=b.Count;
            int va=b.Count; for(int z=0;z<8+e.Values.Count*20;z++) b.Add(0);
            PatchU32(b,va,e.ValueFlags); PatchU32(b,va+4,(uint)e.Values.Count);
            for(int j=0;j<e.Values.Count;j++) {
                ValueRec v=e.Values[j]; int vo=va+8+j*20;
                int vnOff=AppendUnicode(b,v.Name); int vnLen=Encoding.Unicode.GetByteCount(v.Name);
                int vhOff=AppendUnicode(b,v.Host); int vhLen=Encoding.Unicode.GetByteCount(v.Host);
                PatchU32(b,vo,v.Flags); PatchU32(b,vo+4,(uint)vnOff); PatchU32(b,vo+8,(uint)vnLen);
                PatchU32(b,vo+12,(uint)vhOff); PatchU32(b,vo+16,(uint)vhLen);
            }
            PatchU32(b,eo,e.Flags); PatchU32(b,eo-4,(uint)nameOff);
            PatchU32(b,eo+8,(uint)nameLen); PatchU32(b,eo+12,(uint)aliasOff); PatchU32(b,eo+16,(uint)aliasLen); PatchU32(b,eo-20,(uint)dataOff);
            Align4(b);
        }
        PatchU32(b,4,(uint)b.Count);
        return b.ToArray();
    }

    static EntryRec BinaryFind(List<EntryRec> sorted,string name) {
        int lo=0,hi=sorted.Count-1;
        while(lo<=hi){int mid=(lo+hi)>>1;int c=StringComparer.OrdinalIgnoreCase.Compare(name,sorted[mid].Name);if(c<0)hi=mid-1;else if(c>0)lo=mid+1;else return sorted[mid];}
        return null;
    }

    static bool MustUseCompatHost(string name) {
        switch(name.ToLowerInvariant()) {
            case "ms-win-core-kernel32-legacy-l1-1-2":
            case "ms-win-core-synch-l1-2-1":
            case "ms-win-core-heap-l2-1-0":
            case "ms-win-ntuser-sysparams-l1-1-0":
            case "ms-win-core-libraryloader-l1-2-1":
            case "ms-win-core-synch-ansi-l1-1-0":
            case "ms-win-core-file-l1-2-2":
                return true;
            default:
                return false;
        }
    }

    static void VerifyMap(byte[] map) {
        uint f; List<EntryRec> es=ParseMap(map,out f);
        es.Sort(delegate(EntryRec left,EntryRec right){return StringComparer.OrdinalIgnoreCase.Compare(left.Name,right.Name);});
        foreach(Target t in Targets) {
            EntryRec e=BinaryFind(es,t.Name); if(e==null) throw new Exception("Private map self-check missing: "+t.Name);
            string h; if(!HasDefaultHost(e,out h)) throw new Exception("Private map self-check unhosted: "+t.Name);
            if(MustUseCompatHost(t.Name) && !String.Equals(h,t.Host,StringComparison.OrdinalIgnoreCase))
                throw new Exception("Private map self-check compat-host mismatch: "+t.Name+" -> "+h+", expected "+t.Host);
        }
    }

    public static int Run(string exePath,string commandLine,string cwd) {
        STARTUPINFO si=new STARTUPINFO();si.cb=Marshal.SizeOf(typeof(STARTUPINFO));PROCESS_INFORMATION pi;
        uint createFlags=CREATE_SUSPENDED|DEBUG_ONLY_THIS_PROCESS;
        if(!CreateProcessW(exePath,commandLine,IntPtr.Zero,IntPtr.Zero,false,createFlags,IntPtr.Zero,cwd,ref si,out pi))
            throw new Exception("CreateProcessW failed: "+Marshal.GetLastWin32Error());
        Console.WriteLine("[INFO] Target CreateProcessW succeeded. PID={0}, TID={1}",pi.dwProcessId,pi.dwThreadId);
        bool resumed=false;
        try {
            PROCESS_BASIC_INFORMATION pbi=new PROCESS_BASIC_INFORMATION();int ret;
            int st=NtQueryInformationProcess(pi.hProcess,0,ref pbi,Marshal.SizeOf(typeof(PROCESS_BASIC_INFORMATION)),out ret);
            if(st<0) throw new Exception("NtQueryInformationProcess failed: 0x"+st.ToString("X8"));
            IntPtr ptrAddr=new IntPtr(pba.PebBaseAddress.ToInt64()+0x68);
            long oldBase=BitConverter.ToInt64(RPM(pi.hProcess,ptrAddr,8),0);
            byte[] hdr=RPM(pi.hProcess,new IntPtr(oldBase),16); uint ver=U32(hdr,0), size=U32(hdr,4);
            if(ver!=4 || size<16 || size>16*1024*1024) throw new Exception("Unexpected ApiSet map header: version="+ver+", size="+size);
            byte[] oldMap=RPM(pi.hProcess,new IntPtr(oldBase),(int)size);
            uint schemaFlags; List<EntryRec> entries=ParseMap(oldMap,out schemaFlags);
            int originalCount=entries.Count, hosted=0,repaired=0,added=0;

            foreach(Target t in Targets) {
                EntryRec e=Find(entries,t.Name);
                if(e==null) {
                    e=new EntryRec(); e.Flags=0; e.Name=t.Name; e.Alias=""; e.ValueFlags=0;
                    SetDefaultHost(e,t.Host); entries.Add(e); added++;
                    Console.WriteLine("[ADF] {0} -> {1}",t.Name,t.Host);
                    continue;
                }
                string h;
                if(HasDefaultHost(e,out h)) { hosted++; continue; }
                SetDefaultHost(e,t.Host); repaired++;
                Console.WriteLine("[REPAIR] {0} -> {1}",t.Name,t.Host);
            }

            byte[] map=SerializeMap(entries,schemaFlags);
            VerifyMap(map);
            uint vf; List<EntryRec> verifyEntries=ParseMap(map,out vf);
            Console.WriteLine("[INFO] v4 targets: existing-hosted={0}, repaired-unhosted={1}, added-missing={2}",hosted,repaired,added);
            Console.WriteLine("[INFO] Namespace entries: original={0}, private={1}",originalCount,verifyEntries.Count);
            Console.WriteLine("[OK] Self-check: all 17 compatibility contracts are hosted.");

            IntPtr remote=VirtualAllocEx(pi.hProcess,IntPtr.Zero,(UIntPtr)(ulong)map.Length,MEM_COMMIT|MEM_RESERVE,PAGE_READWRITE);
            if(remote==IntPtr.Zero) throw new Exception("VirtualAllocEx failed: "+Marshal.GetLastWin32Error());
            WPM(pi.hProcess,remote,map);
            WPM(pi.hProcess,ptrAddr,BitConverter.GetBytes(remote.ToInt64()));
            long verifyPtr=BitConverter.ToInt64(RPM(pi.hProcess,ptrAddr,8),0);
            if(verifyPtr!=remote.ToInt64()) throw new Exception("ApiSetMap pointer verification failed.");
            Console.WriteLine("[OK] Installed private Windows 8.1 ApiSet v4 map ({0} bytes).",map.Length);

            if(!DebugActiveProcessStop(pi.dwProcessId))
                throw new Exception("DebugActiveProcessStop failed: "+Marshal.GetLastWin32Error());
            uint rr=ResumeTread(pi.hThread);
            if(rr==0xFFFFFFFF) throw new Exception("ResumeThread failed: "+Marshal.GetLastWin32Error());
            resumed=true;
            Console.WriteLine("[OK] Minecraft resumed. Waiting for process exit...");

            uint wr=WaitForSingleObject(pi.hProcess,0xFFFFFFFF);
            if(wr!=0) throw new Exception("WaitForSingleObject failed/result: 0x"+wr.ToString("X8"));
            uint ec;
            if(!GetExitCodeProcess(pi.hProcess,out ec)) throw new Exception("GetExitCodeProcess failed: "+Marshal.GetLastWin32Error());
            Console.WriteLine("[INFO] Minecraft exit code: 0x"+ec.ToString("X8")+" ("+ec+")");
            retur unchecked((int)ec);
        }
        catch { if(!resumed) TerminateProcess(pi.hProcess,0x481); throw; }
        finally { CloseHandle(pi.hThread); CloseHandle(pi.hProcess); }
    }
 }

public static class Program
{
    static StreamWriter LogWriter;

    static void InitLog() {
        string logPath=Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"win81_java_classic_bridge.log");
        try { if(File.Exists(logPath) && new FileInfo(logPath).Length>1048576) File.Delete(logPath); } catch {}
        FileStream fs=new FileStream(logPath,FileMode.Append,FileAccess.Write,FileShare.ReadWrite);
        LogWriter=new StreamWriter(fs,new UTF8Encoding(false));
        LogWriter.AutoFlush=true;
        Console.SetOut(LogWriter);
        Console.SetError(LogWriter);
        Console.WriteLine("");
        Console.WriteLine("====================================================");
        Console.WriteLine(" Minecraft Java Classic Bedrock - Win8.1 Launcher Bridge v1.0.0-RC1");
        Console.WriteLine(" Time: {0}",DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff"));
        Console.WriteLine(" Bridge PID: {0}",System.Diagnostics.Process.GetCurrentProcess().Id);
        Console.WriteLine("====================================================");
    }

    static string QuoteArg(string s) {
        if(s==null) s="";
        if(s.Length>0 && s.IndexOfAny(new char[]{' ','\t','\n','\v','"'})<0) return s;
        StringBuilder b=new StringBuilder(); b.Append('"'); int slashes=0;
        for(int i=0;i<s.Length;i++) {
            char c=s[i];
            if(c=='\\') { slashes++; continue; }
            if(c=='"') { b.Append('\\',slashes*2+1); b.Append('"'); slashes=0; continue; }
            if(slashes>0) { b.Append('\\',slashes); slashes=0; }
            b.Append(c);
        }
        if(slashes>0) b.Append('\\',slashes*2);
        b.Append('"'); return b.ToString();
    }

    static string BuildTargetCommandLine(string[] args) {
        StringBuilder b=new StringBuilder();
        for(int i=0;i<args.Length;i++) {
            if(i>0) b.Append(' ');
            b.Append(QuoteArg(args[i]));
        }
        return b.ToString();
    }

    static bool ContainsAscii(string path,string s) {
        try {
            byte[] d=File.ReadAllBytes(path), n=Encoding.ASCII.GetBytes(s);
            for(int i=0;i<=d.Length-n.Length;i++) {
                bool ok=true;
                for(int j=0;j<n.Length;j++) if(d[i+j]!=n[j]) { ok=false; break; }
                if(ok) return true;
            }
        } catch {}
        return false;
    }

    public static int Main(string[] args) {
        try {
            InitLog();
            Console.WriteLine("[INFO] IFEO argument count: {0}",args==null?0:args.Length);
            if(!Environment.Is64BitProcess) throw new Exception("Bridge must run as x64.");
            if(args==null || args.Length<1) throw new Exception("IFEO did not supply the target Minecraft command line.");

            string target=Path.GetFullPath(args[0]);
            Console.WriteLine("[INFO] Target image: {0}",target);
            Console.WriteLine("[INFO] Extra launcher argument count: {0} (contents intentionally not logged)",Math.Max(0,args.Length-1));
            if(!String.Equals(Path.GetFileName(target),"Minecraft.Windows.exe",StringComparison.OrdinalIgnoreCase))
                throw new Exception("Unexpected IFEO target: "+target);
            if(!File.Exists(target)) throw new FileNotFoundException("Target Minecraft.Windows.exe does not exist.",target);

            Win81ApiSetLauncherV16.ValidateTarget(target);
            string root=Path.GetDirectoryName(target);

            string pix=Path.Combine(root,"WinPixEventRuntime.dll");
            if(File.Exists(pix) && ContainsAscii(pix,"SetThreadDescription"))
                Console.WriteLine("[NOTE] WinPixEventRuntime.dll imports SetThreadDescription. This Java Classic bridge does not patch WinPixEventRuntime.dll because the verified 1.21.120.0 build can enter worlds without that patch.");

            Console.WriteLine("[BRIDGE] Java Classic launcher -> Minecraft.Windows.exe intercepted.");
            Console.WriteLine("[BRIDGE] Launcher arguments will be forwarded unchanged and are not written to this log.");
            string targetCmd=BuildTargetCommandLine(args);
            int code=Win81ApiSetLauncherV16.Run(target,targetCmd,root);
            Console.WriteLine("[INFO] Bridge returning Minecraft exit code: 0x{0:X8}",unchecked((uint)code));
            return code;
        }
        catch(Exception ex) {
            try { Console.Error.WriteLine("[ERROR] Win8.1 Java Classic launcher bridge: "+ex.ToString()); } catch {}
            return 1;
        }
        finally {
            try { if(LogWriter!=null){LogWriter.Flush();LogWriter.Dispose();} } catch {}
        }
    }
}

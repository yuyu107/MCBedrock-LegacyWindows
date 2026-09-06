using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Security.Cryptography;
using Microsoft.Win32;

public static class RawLauncher
{
    const uint CREATE_SUSPENDED=0x00000004, DEBUG_ONLY_THIS_PROCESS=0x00000002;
    [StructLayout(LayoutKind.Sequential, CharSet=CharSet.Unicode)]
    struct STARTUPINFO { public Int32 cb; public string lpReserved,lpDesktop,lpTitle; public Int32 dwX,dwY,dwXSize,dwYSize,dwXCountChars,dwYCountChars,dwFillAttribute,dwFlags; public Int16 wShowWindow,cbReserved2; public IntPtr lpReserved2,hStdInput,hStdOutput,hStdError; }
    [StructLayout(LayoutKind.Sequential)] struct PROCESS_INFORMATION { public IntPtr hProcess,hThread; public UInt32 dwProcessId,dwThreadId; }
    [DllImport("kernel32.dll", CharSet=CharSet.Unicode, SetLastError=true)] static extern bool CreateProcessW(string app,string cmd,IntPtr pa,IntPtr ta,bool inherit,uint flags,IntPtr env,string cwd,ref STARTUPINFO si,out PROCESS_INFORMATION pi);
    [DllImport("kernel32.dll", SetLastError=true)] static extern bool DebugActiveProcessStop(uint pid);
    [DllImport("kernel32.dll", SetLastError=true)] static extern uint ResumeThread(IntPtr ht);
    [DllImport("kernel32.dll", SetLastError=true)] static extern uint WaitForSingleObject(IntPtr h,uint ms);
    [DllImport("kernel32.dll", SetLastError=true)] static extern bool GetExitCodeProcess(IntPtr hp,out uint code);
    [DllImport("kernel32.dll", SetLastError=true)] static extern bool TerminateProcess(IntPtr hp,uint code);
    [DllImport("kernel32.dll", SetLastError=true)] static extern bool CloseHandle(IntPtr h);
    public static int Run(string exe,string cmd,string cwd) {
        STARTUPINFO si=new STARTUPINFO(); si.cb=Marshal.SizeOf(typeof(STARTUPINFO)); PROCESS_INFORMATION pi;
        if(!CreateProcessW(exe,cmd,IntPtr.Zero,IntPtr.Zero,false,CREATE_SUSPENDED|DEBUG_ONLY_THIS_PROCESS,IntPtr.Zero,cwd,ref si,out pi)) throw new Exception("Pass-through CreateProcessW failed: "+Marshal.GetLastWin32Error());
        bool resumed=false;
        try {
            if(!DebugActiveProcessStop(pi.dwProcessId)) throw new Exception("Pass-through DebugActiveProcessStop failed: "+Marshal.GetLastWin32Error());
            uint rr=ResumeThread(pi.hThread); if(rr==0xFFFFFFFF) throw new Exception("Pass-through ResumeThread failed: "+Marshal.GetLastWin32Error());
            resumed=true;
            uint wr=WaitForSingleObject(pi.hProcess,0xFFFFFFFF); if(wr!=0) throw new Exception("Pass-through wait failed: 0x"+wr.ToString("X8"));
            uint ec; if(!GetExitCodeProcess(pi.hProcess,out ec)) throw new Exception("Pass-through GetExitCodeProcess failed: "+Marshal.GetLastWin32Error());
            return unchecked((int)ec);
        } finally { if(!resumed) TerminateProcess(pi.hProcess,1); CloseHandle(pi.hThread); CloseHandle(pi.hProcess); }
    }
}

public static class Program
{
    const string RegRoot=@"SOFTWARE\MCBedrock-LegacyWindows\Win81UniversalBridge\Targets";
    static StreamWriter LogWriter;
    static string SharedDir { get { return AppDomain.CurrentDomain.BaseDirectory.TrimEnd('\\'); } }

    static void InitLog() {
        string logPath=Path.Combine(SharedDir,"win81_universal_bridge.log");
        try { if(File.Exists(logPath) && new FileInfo(logPath).Length>2097152) File.Delete(logPath); } catch {}
        FileStream fs=new FileStream(logPath,FileMode.Append,FileAccess.Write,FileShare.ReadWrite);
        LogWriter=new StreamWriter(fs,new UTF8Encoding(false)); LogWriter.AutoFlush=true; Console.SetOut(LogWriter); Console.SetError(LogWriter);
        Console.WriteLine(""); Console.WriteLine("====================================================");
        Console.WriteLine(" MCBedrock Win8.1 Universal Bridge coexistence test v0.1");
        Console.WriteLine(" Time: {0}",DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff"));
        Console.WriteLine(" Bridge PID: {0}",System.Diagnostics.Process.GetCurrentProcess().Id);
        Console.WriteLine("====================================================");
    }
    static string NormalizePath(string p){ return Path.GetFullPath(p).TrimEnd('\\'); }
    static string PathKey(string p) {
        byte[] d=Encoding.UTF8.GetBytes(NormalizePath(p).ToLowerInvariant());
        using(SHA256 s=SHA256.Create()) { byte[] h=s.ComputeHash(d); StringBuilder b=new StringBuilder(); foreach(byte x in h)b.Append(x.ToString("x2")); return b.ToString(); }
    }
    static string ReadMode(string target) {
        string key=PathKey(target);
        using(RegistryKey baseKey=RegistryKey.OpenBaseKey(RegistryHive.LocalMachine,RegistryView.Registry64))
        using(RegistryKey k=baseKey.OpenSubKey(RegRoot+"\\"+key,false)) {
            if(k==null) return null;
            string saved=Convert.ToString(k.GetValue("Path","")); string mode=Convert.ToString(k.GetValue("Mode",""));
            if(!String.Equals(NormalizePath(saved),NormalizePath(target),StringComparison.OrdinalIgnoreCase)) return null;
            return mode;
        }
    }
    static string QuoteArg(string s) {
        if(s==null)s=""; if(s.Length>0 && s.IndexOfAny(new char[]{' ','\t','\n','\v','"'})<0)return s;
        StringBuilder b=new StringBuilder(); b.Append('"'); int slashes=0;
        for(int i=0;i<s.Length;i++){char c=s[i]; if(c=='\\'){slashes++;continue;} if(c=='"'){b.Append('\\',slashes*2+1);b.Append('"');slashes=0;continue;} if(slashes>0){b.Append('\\',slashes);slashes=0;} b.Append(c);} if(slashes>0)b.Append('\\',slashes*2); b.Append('"'); return b.ToString();
    }
    static string BuildTargetCommandLine(string[] args){StringBuilder b=new StringBuilder();for(int i=0;i<args.Length;i++){if(i>0)b.Append(' ');b.Append(QuoteArg(args[i]));}return b.ToString();}
    static bool ContainsAscii(byte[] data,string text){byte[] n=Encoding.ASCII.GetBytes(text);for(int i=0;i<=data.Length-n.Length;i++){bool ok=true;for(int j=0;j<n.Length;j++)if(data[i+j]!=n[j]){ok=false;break;}if(ok)return true;}return false;}
    static void CheckInteropWinPixState(string root) {
        string pix=Path.Combine(root,"WinPixEventRuntime.dll"); if(!File.Exists(pix)){Console.WriteLine("[INTEROP] WinPixEventRuntime.dll not present; no WinPix action needed.");return;}
        byte[] d=File.ReadAllBytes(pix);
        if(ContainsAscii(d,"W81KERN.dll")) {
            string shim=Path.Combine(root,"W81KERN.dll");
            if(!File.Exists(shim)) throw new Exception("Interop WinPix is redirected to W81KERN.dll but W81KERN.dll is missing in the game directory. Restore/reinstall the verified Interop v2.0.1 WinPix compatibility files first.");
            Console.WriteLine("[INTEROP] Existing verified WinPix -> W81KERN redirection detected; reusing it."); return;
        }
        if(ContainsAscii(d,"SetThreadDescription")) {
            throw new Exception("Interop mode still needs the existing WinPix/W81KERN compatibility step. For this coexistence test, first launch/install the verified Interop v2.0.1 bridge once so WinPixEventRuntime.dll is prepared, then register this Interop path again.");
        }
        Console.WriteLine("[INTEROP] This WinPix build does not appear to require SetThreadDescription compatibility.");
    }
    public static int Main(string[] args) {
        try {
            InitLog();
            if(!Environment.Is64BitProcess) throw new Exception("Universal Bridge must run as x64.");
            Console.WriteLine("[INFO] IFEO argument count: {0}",args==null?0:args.Length);
            if(args==null || args.Length<1) throw new Exception("IFEO did not supply the target command line.");
            string target=NormalizePath(args[0]);
            if(!String.Equals(Path.GetFileName(target),"Minecraft.Windows.exe",StringComparison.OrdinalIgnoreCase)) throw new Exception("Unexpected IFEO target: "+target);
            if(!File.Exists(target)) throw new FileNotFoundException("Target does not exist.",target);
            Console.WriteLine("[INFO] Target: {0}",target);
            Console.WriteLine("[INFO] Extra launcher argument count: {0} (contents intentionally not logged)",Math.Max(0,args.Length-1));
            string mode=ReadMode(target); string cmd=BuildTargetCommandLine(args); string root=Path.GetDirectoryName(target);
            if(String.IsNullOrEmpty(mode)) {
                Console.WriteLine("[PASS] Target path is not registered. Launching unchanged without ApiSet/WinPix compatibility modifications.");
                return RawLauncher.Run(target,cmd,root);
            }
            Console.WriteLine("[ROUTE] Registered mode: {0}",mode);
            Win81ApiSetLauncherV16.ValidateTarget(target);
            if(String.Equals(mode,"interop",StringComparison.OrdinalIgnoreCase)) CheckInteropWinPixState(root);
            else if(!String.Equals(mode,"java-classic",StringComparison.OrdinalIgnoreCase)) throw new Exception("Unknown registered mode: "+mode);
            int code=Win81ApiSetLauncherV16.Run(target,cmd,root);
            Console.WriteLine("[INFO] Mode {0} returned exit code 0x{1:X8}",mode,unchecked((uint)code));
            return code;
        } catch(Exception ex) { try{Console.Error.WriteLine("[ERROR] Universal Bridge: "+ex.ToString());}catch{} return 1; }
        finally { try{if(LogWriter!=null){LogWriter.Flush();LogWriter.Dispose();}}catch{} }
    }
}

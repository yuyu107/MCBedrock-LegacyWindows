using System;
using System.IO;
using System.Text;
public static class Program
{
    static StreamWriter LogWriter;
    static void InitLog() {
        string logPath=Path.Combine(AppDomain.CurrentDomain.BaseDirectory,"win81_launcher_bridge.log");
        try { if(File.Exists(logPath) && new FileInfo(logPath).Length>1048576) File.Delete(logPath); } catch {}
        FileStream fs=new FileStream(logPath,FileMode.Append,FileAccess.Write,FileShare.ReadWrite);
        LogWriter=new StreamWriter(fs,new UTF8Encoding(false));
        LogWriter.AutoFlush=true;
        Console.SetOut(LogWriter);
        Console.SetError(LogWriter);
        Console.WriteLine("");
        Console.WriteLine("====================================================");
        Console.WriteLine(" MCBedrock Win8.1 Launcher-Login Bridge v2.0.1 Release");
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
        for(int i=0;i<args.Length;i++) { if(i>0)b.Append(' '); b.Append(QuoteArg(args[i])); }
        return b.ToString();
    }

    static int FindAscii(byte[] data,string text) {
        byte[] n=Encoding.ASCII.GetBytes(text);
        for(int i=0;i<=data.Length-n.Length;i++) {
            bool ok=true; for(int j=0;j<n.Length;j++) if(data[i+j]!=n[j]) {ok=false;break;}
            if(ok) return i;
        }
        return -1;
    }
    static int CountAscii(byte[] data,string text) {
        byte[] n=Encoding.ASCII.GetBytes(text); int count=0;
        for(int i=0;i<=data.Length-n.Length;i++) {
            bool ok=true; for(int j=0;j<n.Length;j++) if(data[i+j]!=n[j]) {ok=false;break;}
            if(ok) count++;
        }
        return count;
    }
    static string Sha256Prefix(byte[] data) {
        using(System.Security.Cryptography.SHA256 sha=System.Security.Cryptography.SHA256.Create()) {
            byte[] h=sha.ComputeHash(data); StringBuilder s=new StringBuilder();
            for(int i=0;i<6;i++) s.Append(h[i].ToString("x2")); return s.ToString();
        }
    }
    static bool FilesEqual(string a,string b) {
        FileInfo fa=new FileInfo(a), fb=new FileInfo(b);
        if(!fa.Exists || !fb.Exists || fa.Length!=fb.Length) return false;
        const int Buf=65536; byte[] ba=new byte[Buf], bb=new byte[Buf];
        using(FileStream sa=new FileStream(a,FileMode.Open,FileAccess.Read,FileShare.ReadWrite|FileShare.Delete))
        using(FileStream sb=new FileStream(b,FileMode.Open,FileAccess.Read,FileShare.ReadWrite|FileShare.Delete)) {
            while(true) {
                int na=sa.Read(ba,0,ba.Length), nb=sb.Read(bb,0,bb.Length);
                if(na!=nb) return false;
                if(na==0) return true;
                for(int i=0;i<na;i++) if(ba[i]!=bb[i]) return false;
            }
        }
    }
    static void EnsureWinPixCompat(string root,string bridgeDir) {
        string pix=Path.Combine(root,"WinPixEventRuntime.dll");
        if(!File.Exists(pix)) return;
        byte[] data=File.ReadAllBytes(pix);
        if(FindAscii(data,"SetThreadDescription")<0) return;
        string shimSrc=Path.Combine(bridgeDir,"W81KERN.dll");
        string shimDst=Path.Combine(root,"W81KERN.dll");
        if(!File.Exists(shimSrc)) throw new Exception("W81KERN.dll is missing beside Win81MinecraftBridge.exe.");
        if(String.Equals(Path.GetFullPath(shimSrc),Path.GetFullPath(shimDst),StringComparison.OrdinalIgnoreCase) && FindAscii(data,"W81KERN.dll")>=0) {
            Console.WriteLine("[OK] WinPix is already redirected and W81KERN.dll is already in the game/bridge directory; no copy is needed.");
            return;
        }
        if(FindAscii(data,"W81KERN.dll")>=0) {
            if(File.Exists(shimDst)) {
                if(FilesEqual(shimSrc,shimDst)) {
                    Console.WriteLine("[OK] WinPix is already redirected and the existing W81KERN.dll matches this bridge; reusing it without overwrite.");
                    return;
                }
                try { File.Copy(shimSrc,shimDst,true); }
                catch(IOException ex) {
                    throw new IOException("W81KERN.dll already exists but differs from this bridge build and is currently in use. Close every Minecraft.Windows.exe process (or reboot), then install/start again. The existing DLL was not changed.",ex);
                }
                Console.WriteLine("[UPDATE] Replaced an older W81KERN.dll for the already-patched WinPixEventRuntime.dll.");
                return;
            }
            File.Copy(shimSrc,shimDst,false);
            Console.WriteLine("[OK] WinPix is already redirected; installed the missing W81KERN.dll.");
            return;
        }
        int count=CountAscii(data,"KERNEL32.dll");
        if(count!=1) throw new Exception("WinPix safety check failed: expected one KERNEL32.dll import string, found "+count+".");
        string backup=Path.Combine(root,"WinPixEventRuntime.dll.win81bak_"+Sha256Prefix(data));
        if(!File.Exists(backup)) File.WriteAllBytes(backup,data);
        int pos=FindAscii(data,"KERNEL32.dll"); byte[] repl=Encoding.ASCII.GetBytes("W81KERN.dll");
        for(int i=0;i<repl.Length;i++) data[pos+i]=repl[i]; data[pos+repl.Length]=0;
        File.WriteAllBytes(pix,data); File.Copy(shimSrc,shimDst,true);
        Console.WriteLine("[PATCH] WinPixEventRuntime.dll redirected to W81KERN.dll for SetThreadDescription compatibility.");
    }

    public static int Main(string[] args) {
        try {
            InitLog();
            Console.WriteLine("[INFO] IFEO argument count: {0}",args==null?0:args.Length);
            if(args==null || args.Length<1) throw new Exception("IFEO did not supply the target Minecraft command line.");
            string target=Path.GetFullPath(args[0]);
            Console.WriteLine("[INFO] Target image: {0}",target);
            Console.WriteLine("[INFO] Extra launcher/auth argument count: {0} (contents intentionally not logged)",Math.Max(0,args.Length-1));
            if(!String.Equals(Path.GetFileName(target),"Minecraft.Windows.exe",StringComparison.OrdinalIgnoreCase))
                throw new Exception("Unexpected IFEO target: "+target);
            Win81ApiSetLauncherV16.ValidateTarget(target);
            string root=Path.GetDirectoryName(target); string bridgeDir=AppDomain.CurrentDomain.BaseDirectory;
            EnsureWinPixCompat(root,bridgeDir);
            string targetCmd=BuildTargetCommandLine(args);
            Console.WriteLine("[BRIDGE] FeverGamesLauncher -> Minecraft.Windows.exe intercepted for Win8.1 compatibility.");
            Console.WriteLine("[BRIDGE] Authentication arguments are forwarded unchanged but are not printed or saved.");
            int code=Win81ApiSetLauncherV16.Run(target,targetCmd,root);
            Console.WriteLine("[INFO] Bridge returning target exit code: 0x{0:X8}",unchecked((uint)code));
            return code;
        } catch(Exception ex) {
            try { Console.Error.WriteLine("[ERROR] Win8.1 launcher bridge: "+ex.ToString()); } catch {}
            return 1;
        } finally {
            try { if(LogWriter!=null){LogWriter.Flush();LogWriter.Dispose();} } catch {}
        }
    }
}

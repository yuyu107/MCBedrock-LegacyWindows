#include <windows.h>

/*
 * Windows 8.1 compatibility stub used only by WinPixEventRuntime.dll.
 *
 * Windows 8.1 does not provide SetThreadDescription (introduced later in
 * Windows 10). WinPix only uses it to attach a human-readable name to a
 * thread, so returning S_OK is sufficient for this compatibility layer.
 *
 * All other exports required by WinPix are forwarded to the system
 * KERNEL32.dll by W81KERN.def.
 */
HRESULT WINAPI SetThreadDescription(HANDLE hThread, PCWSTR lpThreadDescription)
{
    (void)hThread;
    (void)lpThreadDescription;
    return S_OK;
}

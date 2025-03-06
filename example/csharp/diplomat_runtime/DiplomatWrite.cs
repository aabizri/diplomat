using System.Runtime.InteropServices;
using System.Runtime.CompilerServices;

namespace SomeLib.DiplomatRuntime;

/// <code>
/// typedef struct DiplomatWrite {
/// void* context;
/// char* buf;
/// size_t len;
/// size_t cap;
/// bool grow_failed;
/// void(*flush)(struct DiplomatWrite*);
/// bool(*grow)(struct DiplomatWrite*, size_t);
/// } DiplomatWrite;
/// </code>
[StructLayout(LayoutKind.Sequential)]
internal unsafe struct DiplomatWrite
{
    public void* context;
    public byte* buf;
    public nuint len;
    public nuint cap;
    public byte grow_failed;
    public delegate* unmanaged[Cdecl]<IntPtr, void> /* should be DiplomatWrite*/ flush;
    public delegate* unmanaged[Cdecl]<IntPtr, nuint, byte> grow;
};


// See https://learn.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.nativememory?view=net-9.0
internal static class DiplomatWriteExtensions {
    internal static DiplomatWrite WithCapacity(nuint size) {
        unsafe {
            void* buffer;
            buffer = NativeMemory.AlignedAlloc((UIntPtr)size, (UIntPtr)1);

            
            DiplomatWrite dw = new() {
                context = null,
                buf = (byte*)buffer,
                len = 0,
                cap = size,
                grow_failed = System.Convert.ToByte(false),
                flush = &DiplomatWriteExtensions.FFIFlush,
                grow = &DiplomatWriteExtensions.FFIGrow
            };

            return dw;
        }
    }

    internal static void Destroy(this DiplomatWrite dw) {
        unsafe {
            NativeMemory.AlignedFree(dw.buf);
        }
    }

    /// <summary>
    /// If an exception is thrown, it is guaranteed that dw will still be valid
    /// </summary>
    private static void Grow(this DiplomatWrite dw, nuint newSize) {
        unsafe {
            void* newPtr = NativeMemory.AlignedRealloc(dw.buf, (UIntPtr)newSize, (UIntPtr)1);
            dw.buf = (byte*)newPtr;
        }
    }

    internal static string ToString(this DiplomatWrite dw) {
        if (dw.len > dw.cap) {
            throw new System.Exception("Invalid DiplomatWrite state: len exceeds cap");
        }
        String output;
        unsafe {
            output = System.Text.Encoding.UTF8.GetString(dw.buf, (int)dw.len);
        }
        return output;
    }

    
    // Called from rust only
    [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvCdecl) })]
    private unsafe static void FFIFlush(IntPtr dwPtr) {
        DiplomatWrite* ptr = (DiplomatWrite*)dwPtr.ToPointer();
        // TODO
    }

    // Called from rust only
    [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvCdecl) })]
    private unsafe static byte FFIGrow(IntPtr dwPtr, nuint newSize) {
        DiplomatWrite* ptr = (DiplomatWrite*)dwPtr.ToPointer();
        try {
            ptr->Grow(newSize);
            return System.Convert.ToByte(true);
        } catch {
            return System.Convert.ToByte(false);
        }
    }
}


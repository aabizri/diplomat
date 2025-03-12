using System.Runtime.InteropServices;
using System.Runtime.CompilerServices;

namespace SomeLib.DiplomatRuntime;

// Regarding alloc, see https://learn.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.marshal.allochglobal?view=net-9.0
// Especially:
// - When targeting .NET 6 or later, use the NativeMemory class on all platforms to allocate native memory.
// - When targeting earlier than .NET 6 , use AllocCoTaskMem on all platforms to allocate native memory.


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


#if NETCOREAPP1_0_OR_GREATER
    public delegate* unmanaged[Cdecl]<IntPtr, void> /* should be DiplomatWrite*/ flush;
    public delegate* unmanaged[Cdecl]<IntPtr, nuint, byte> grow;
#else
    public IntPtr flush;
    public IntPtr grow;
#endif
};


// See https://learn.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.nativememory?view=net-9.0
internal static class DiplomatWriteExtensions {

#if !NETCOREAPP1_0_OR_GREATER
    internal class DelegateTypes
    {
        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        public delegate void FlushDelegate(IntPtr self);

        [UnmanagedFunctionPointer(CallingConvention.Cdecl)]
        public delegate byte GrowDelegate(IntPtr self, nuint newSize);
    }
#endif

    internal static DiplomatWrite WithCapacity(nuint size)
    {
        unsafe
        {
            void* buffer;
#if NET6_OR_GREATER
            buffer = NativeMemory.AlignedAlloc((UIntPtr)size, (UIntPtr)1);
#else
            buffer = (void*)Marshal.AllocCoTaskMem((int)size);
#endif


            DiplomatWrite dw = new()
            {
                context = null,
                buf = (byte*)buffer,
                len = 0,
                cap = size,
                grow_failed = System.Convert.ToByte(false),
#if NETCOREAPP1_0_OR_GREATER
                flush = &DiplomatWriteExtensions.FFIFlush,
                grow = &DiplomatWriteExtensions.FFIGrow
#else
                flush = Marshal.GetFunctionPointerForDelegate<DelegateTypes.FlushDelegate>(FFIFlush),
                grow = Marshal.GetFunctionPointerForDelegate<DelegateTypes.GrowDelegate>(FFIGrow)
#endif
            };

            return dw;
        }
    }

    internal static void Destroy(this DiplomatWrite dw) {
        unsafe
        {
#if NET6_OR_GREATER
            NativeMemory.AlignedFree(dw.buf);
#else
            Marshal.FreeCoTaskMem((IntPtr)dw.buf);
#endif
        }
    }

    /// <summary>
    /// If an exception is thrown, it is guaranteed that dw will still be valid
    /// </summary>
    private static void Grow(this DiplomatWrite dw, nuint newSize) {
        unsafe
        {
#if NET6_OR_GREATER
            void* newPtr = NativeMemory.AlignedRealloc(dw.buf, (UIntPtr)newSize, (UIntPtr)1);
            dw.buf = (byte*)newPtr;
#else
            IntPtr newPtr = Marshal.ReAllocCoTaskMem((IntPtr)dw.buf, (int)newSize);
            dw.buf = (byte*)newPtr;
#endif
        }
    }

    internal static string ToString(this DiplomatWrite dw) {
        if (dw.len > dw.cap) {
            throw new System.Exception("Invalid DiplomatWrite state: len exceeds cap");
        }
        string output;
        unsafe
        {
            output = System.Text.Encoding.UTF8.GetString(dw.buf, (int)dw.len);
        }
        return output;
    }


    // Called from rust only
#if NET5_0_OR_GREATER
    [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvCdecl) })]
#endif
    private unsafe static void FFIFlush(IntPtr dwPtr)
    {
        DiplomatWrite* ptr = (DiplomatWrite*)dwPtr.ToPointer();
        // TODO
    }

    // Called from rust only
#if NET5_0_OR_GREATER
    [UnmanagedCallersOnly(CallConvs = new[] { typeof(CallConvCdecl) })]
#endif
    private unsafe static byte FFIGrow(IntPtr dwPtr, nuint newSize)
    {
        DiplomatWrite* ptr = (DiplomatWrite*)dwPtr.ToPointer();
        try {
            ptr->Grow(newSize);
            return System.Convert.ToByte(true);
        } catch {
            return System.Convert.ToByte(false);
        }
    }
}


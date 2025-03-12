using System.Runtime.InteropServices;

namespace SomeLib.FFI;

internal static unsafe partial class Library
{
    [DllImport(
        __DllName,
        EntryPoint = "my_collection_new",
        CallingConvention = CallingConvention.Cdecl,
        ExactSpelling = true
    )]
    public static extern void* MyCollectionNew();

#if NET6_0_OR_GREATER
    [UnmanagedCallConv(CallConvs = new Type[] { typeof(System.Runtime.CompilerServices.CallConvCdecl) })]
#endif
#if NET7_0_OR_GREATER
    [LibraryImport(
        __DllName,
        EntryPoint = "my_collection_destroy"
    )]
    public static partial
#else
    [DllImport(
        __DllName,
        EntryPoint = "my_collection_destroy",
#if !NET6_0_OR_GREATER
        CallingConvention = CallingConvention.Cdecl,
#endif
        ExactSpelling = true
    )]
    public static extern
#endif    
    void MyCollectionDestroy(void* self);

    [DllImport(
        __DllName,
        EntryPoint = "my_collection_index",
        CallingConvention = CallingConvention.Cdecl,
        ExactSpelling = true
    )]
    public static extern DiplomatRuntime.DiplomatResultVoidError<float> MyCollectionIndex(void* self, nuint idx);
}

using System.Runtime.InteropServices;

namespace SomeLib.FFI;

internal static unsafe partial class Library
{
    [DllImport(
        __DllName,
        EntryPoint = "my_struct_new",
        CallingConvention = CallingConvention.Cdecl,
        ExactSpelling = true
    )]
    public static extern MyStruct MyStructNew();

    [DllImport(
        __DllName,
        EntryPoint = "my_struct_format",
        CallingConvention = CallingConvention.Cdecl,
        ExactSpelling = true
    )]
    public static extern void MyStructFormat(MyStruct self, DiplomatRuntime.DiplomatWrite* dw);

    [DllImport(
        __DllName,
        EntryPoint = "my_struct_get_something",
        CallingConvention = CallingConvention.Cdecl,
        ExactSpelling = true
    )]
    public static extern DiplomatRuntime.DiplomatResult<byte, byte> MyStructGetSomething(MyStruct self);

    [DllImport(
        __DllName,
        EntryPoint = "my_struct_static_not_constructor",
        CallingConvention = CallingConvention.Cdecl,
        ExactSpelling = true
    )]
    public static extern MyStruct MyStructStaticNotConstructor();
}

[StructLayout(LayoutKind.Sequential)]
internal unsafe struct MyStruct {
    internal byte a;
    internal short b;
    internal sbyte c;
    internal ushort d;
    // This is a boolean
    internal byte myBool;
}

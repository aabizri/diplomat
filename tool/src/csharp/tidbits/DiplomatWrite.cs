[DisableRuntimeMarshalling]

using System.Runtime.InteropServices;

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
    [MarshalAs(UnmanagedType.U1)] public bool grow_failed;
    public delegate* unmanaged[Cdecl]<void*, void> /* should be DiplomatWrite*/ flush;
    public delegate* unmanaged[Cdecl]<void*, nuint, byte> grow;
}
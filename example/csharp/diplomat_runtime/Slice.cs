using System.Runtime.InteropServices;

namespace SomeLib.DiplomatRuntime;


/// <summary>
/// FFI-Compatible result type where the success value is a void type
/// </summary>
/// <typeparam name="T">type of the slice member</typeparam>
[StructLayout(LayoutKind.Sequential)]
internal unsafe struct DiplomatSlice<T> where T : unmanaged
{
    unsafe public T* Data;
    public nuint Length;

    /// Create a new DiplomatSlice instance at the given pointer and size
    /// </summary>
    /// <remarks>It is assumed that the span provided is already unmanaged or externally pinned</remarks>
    public unsafe static DiplomatSlice<T> FromSpan(Span<T> span)
    {
        DiplomatSlice<T> slice = new();
        fixed (T* ptr = &MemoryMarshal.GetReference(span))
        {
            slice.Data = ptr;
            slice.Length = (nuint)span.Length;
        }
        return slice;
    }

    // <summary>
    /// Create a new DiplomatSlice instance at the given pointer and size
    /// </summary>
    public unsafe static DiplomatSlice<T> FromUnmanaged(T* pointer, nuint length)
    {
        DiplomatSlice<T> slice = new()
        {
            Data = pointer,
            Length = length
        };
        return slice;
    }


    /// <summary>
    /// Obtains a span that represents the region
    /// </summary>
    public readonly Span<T> GetSpan() => new(Data, (int)Length);
}

/// <summary>
/// A MemoryManager over a DiplomatSlice. See https://stackoverflow.com/questions/52190423/c-sharp-access-unmanaged-array-using-memoryt-or-arraysegmentt
/// </summary>
/// <remarks>The pointer is assumed to be fully unmanaged, or externally pinned - no attempt will be made to pin this data</remarks>
internal sealed unsafe class UnmanagedMemoryManager<T> : System.Buffers.MemoryManager<T>
    where T : unmanaged
{
    private readonly DiplomatSlice<T> _slice;

    public UnmanagedMemoryManager(DiplomatSlice<T> slice) {
        _slice = slice;
    }

    /// <summary>
    /// Obtains a span that represents the region
    /// </summary>
    public override Span<T> GetSpan() => new(_slice.Data, (int)_slice.Length);

    /// <summary>
    /// Provides access to a pointer that represents the data (note: no actual pin occurs)
    /// </summary>
    public override System.Buffers.MemoryHandle Pin(int elementIndex = 0)
    {
#if NET8_0_OR_GREATER
        ArgumentOutOfRangeException.ThrowIfNegative(elementIndex);
#else
        if ((nuint)elementIndex < 0)
            throw new ArgumentOutOfRangeException(nameof(elementIndex));
#endif

        if ((nuint)elementIndex >= _slice.Length)
            throw new ArgumentOutOfRangeException(nameof(elementIndex));

        return new System.Buffers.MemoryHandle(_slice.Data + elementIndex);
    }

    /// <summary>
    /// Has no effect
    /// </summary>
    public override void Unpin() { }

    /// <summary>
    /// Releases all resources associated with this object
    /// </summary>
    protected override void Dispose(bool disposing) { }
}
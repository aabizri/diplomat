using System.Runtime.InteropServices;

namespace SomeLib.DiplomatRuntime;

// reference on unmanaged constraints: https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/generics/constraints-on-type-parameters#unmanaged-constraint


// Generics work with the StructLayout attribute
[StructLayout(LayoutKind.Explicit)]
internal struct DiplomatResultUnion<T, E>
    where T : unmanaged
    where E : unmanaged
{
    [FieldOffset(0)]
    public T ok;
    [FieldOffset(0)]
    public E err;
}

/// <summary>
/// FFI-Compatible result type where there is no void type
/// </summary>
/// <typeparam name="T">success value type</typeparam>
/// <typeparam name="E">error type</typeparam>
[StructLayout(LayoutKind.Sequential)]
internal struct DiplomatResult<T, E> 
    where T : unmanaged
    where E : unmanaged
{
    public DiplomatResultUnion<T, E> union;
    public byte isOk;

    public static DiplomatResult<T, E> Ok(T value)
    {
        return new DiplomatResult<T, E>() {
            union = new DiplomatResultUnion<T, E>()
            {
                ok = value
            },
            isOk = Convert.ToByte(true)
        };
    }

    public static DiplomatResult<T, E> Err(E value)
    {
        return new DiplomatResult<T, E>()
        {
            union = new DiplomatResultUnion<T, E>()
            {
                err = value
            },
            isOk = Convert.ToByte(false)
        };
    }

    public readonly T Unwrap() {
        if (this.isOk) {
            return union.ok;
        } else {
            throw new System.Exception("TODO: Error");
        }
    }
}

/// <summary>
/// FFI-Compatible result type where the error is a void type
/// </summary>
/// <typeparam name="T">success value type</typeparam>
[StructLayout(LayoutKind.Sequential)]
internal struct DiplomatResultVoidError<T> where T : unmanaged
{
    public T value;
    public byte isOk;

    public static DiplomatResultVoidError<T> Ok(T value)
    {
        return new DiplomatResultVoidError<T>()
        {
            value = value,
            isOk = Convert.ToByte(true)
        };
    }

    public static DiplomatResultVoidError<T> Err()
    {
        return new DiplomatResultVoidError<T>()
        {
            isOk = Convert.ToByte(false)
        };
    }
}

/// <summary>
/// FFI-Compatible result type where the success value is a void type
/// </summary>
/// <typeparam name="E">error type</typeparam>
[StructLayout(LayoutKind.Sequential)]
internal struct DiplomatResultVoidSuccess<E> where E : unmanaged
{
    public E value;
    public byte isOk;

    public static DiplomatResultVoidSuccess<E> Ok()
    {
        return new DiplomatResultVoidSuccess<E>()
        {
            isOk = Convert.ToByte(true)
        };
    }

    public static DiplomatResultVoidSuccess<E> Err(E err)
    {
        return new DiplomatResultVoidSuccess<E>()
        {
            value = err,
            isOk = Convert.ToByte(false)
        };
    }
}

/// <summary>
/// FFI-Compatible result type where the success value and error value are both void type
/// Essentially, this means it only carries the discrimination tag
/// </summary>
[StructLayout(LayoutKind.Sequential)]
internal struct DiplomatResultVoid
{
    public byte isOk;

    public static DiplomatResultVoid Ok()
    {
        return new DiplomatResultVoid()
        {
            isOk = Convert.ToByte(true)
        };
    }

    public static DiplomatResultVoid Err()
    {
        return new DiplomatResultVoid()
        {
            isOk = Convert.ToByte(false)
        };
    }
}
namespace SomeLib.DiplomatRuntime;


/// <summary>
/// Exception from native (FFI), without associated type information
/// </summary>
public class FFIException : System.Exception
{
    public FFIException() : base("The FFI function failed");
}


/// <summary>
/// Exception carrying a native (FFI) information type as well
/// </summary>
/// <typeparam name="E"></typeparam>
public class FFIExceptionWithInfo<E> : FFIException
{
    // TODO: correct printing
    public FFIExceptionWithInfo<E>(E inner) : base("The FFI function failed with an error: {inner}") {
        this.inner = inner;
    }

    public readonly E inner;
}
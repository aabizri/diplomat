using System.Runtime.InteropServices;

namespace SomeLib;

public class MyCollection
{
    unsafe private void* ffi;

    public MyCollection()
    {
        unsafe
        {
            this.ffi = FFI.Library.MyCollectionNew();
        }
    }

    ~MyCollection()
    {
        unsafe
        {
            FFI.Library.MyCollectionDestroy(this.ffi);
        }
    }


}
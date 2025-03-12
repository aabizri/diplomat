// generated by diplomat-tool
// dart format off

// ignore: unused_import
import 'dart:core' as core;
// ignore: unused_import
import 'dart:typed_data';
// ignore: unused_shown_name
import 'dart:core' show int, double, bool, String, Object, override;
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart' as ffi2 show Arena, calloc;
import 'package:meta/meta.dart' as meta;
part 'AttrOpaque1Renamed.g.dart';
part 'Bar.g.dart';
part 'BorrowedFields.g.dart';
part 'BorrowedFieldsReturning.g.dart';
part 'BorrowedFieldsWithBounds.g.dart';
part 'ContiguousEnum.g.dart';
part 'CyclicStructA.g.dart';
part 'CyclicStructB.g.dart';
part 'CyclicStructC.g.dart';
part 'DefaultEnum.g.dart';
part 'ErrorEnum.g.dart';
part 'ErrorStruct.g.dart';
part 'Float64Vec.g.dart';
part 'Foo.g.dart';
part 'ImportedStruct.g.dart';
part 'MyEnum.g.dart';
part 'MyOpaqueEnum.g.dart';
part 'MyString.g.dart';
part 'MyStruct.g.dart';
part 'MyStructContainingAnOption.g.dart';
part 'MyZst.g.dart';
part 'NestedBorrowedFields.g.dart';
part 'One.g.dart';
part 'Opaque.g.dart';
part 'OpaqueMutexedString.g.dart';
part 'OpaqueThin.g.dart';
part 'OpaqueThinIter.g.dart';
part 'OpaqueThinVec.g.dart';
part 'OptionEnum.g.dart';
part 'OptionInputStruct.g.dart';
part 'OptionOpaque.g.dart';
part 'OptionOpaqueChar.g.dart';
part 'OptionStruct.g.dart';
part 'RefList.g.dart';
part 'RefListParameter.g.dart';
part 'RenamedAttrEnum.g.dart';
part 'RenamedAttrOpaque2.g.dart';
part 'RenamedComparable.g.dart';
part 'RenamedMyIndexer.g.dart';
part 'RenamedMyIterable.g.dart';
part 'RenamedMyIterator.g.dart';
part 'RenamedNested.g.dart';
part 'RenamedNested2.g.dart';
part 'RenamedOpaqueIterable.g.dart';
part 'RenamedOpaqueIterator.g.dart';
part 'RenamedStructWithAttrs.g.dart';
part 'ResultOpaque.g.dart';
part 'Two.g.dart';
part 'UnimportedEnum.g.dart';
part 'Unnamespaced.g.dart';
part 'Utf16Wrap.g.dart';

class _DiplomatFfiUse extends meta.RecordUse {
  final String symbol;

  const _DiplomatFfiUse(@meta.mustBeConst this.symbol);
}

/// A [Rune] is a Unicode code point, such as `a`, or `💡`.
/// 
/// The recommended way to obtain a [Rune] is to create it from a 
/// [String], which is conceptually a sequence of [Rune]s. For
/// example, `'a'.runes.first` is equal to the [Rune] `a`.
/// 
/// Dart does not have a character/rune literal (https://github.com/dart-lang/language/issues/886),
/// so integer literals need to be used. For example the Unicode code point 
/// U+1F4A1, `💡`, can be represented by `0x1F4A1`.
///
/// A [String] can be constructed from a [Rune] using (the [confusingly named](
/// https://github.com/dart-lang/sdk/issues/56304)) [String.fromCharCode]. 
typedef Rune = int;

// ignore: unused_element
final _callocFree = core.Finalizer(ffi2.calloc.free);

// ignore: unused_element
final _nopFree = core.Finalizer((nothing) => {});

// ignore: unused_element
final _rustFree = core.Finalizer((({ffi.Pointer<ffi.Void> pointer, int bytes, int align}) record) => _diplomat_free(record.pointer, record.bytes, record.align));

// ignore: unused_element
final class _RustAlloc implements ffi.Allocator {
  @override
  ffi.Pointer<T> allocate<T extends ffi.NativeType>(int byteCount, {int? alignment}) {
      return _diplomat_alloc(byteCount, alignment ?? 1).cast();
  }

  @override
  void free(ffi.Pointer<ffi.NativeType> pointer) {
    throw 'Internal error: should not deallocate in Rust memory';
  }
}

@_DiplomatFfiUse('diplomat_alloc')
@ffi.Native<ffi.Pointer<ffi.Void> Function(ffi.Size, ffi.Size)>(symbol: 'diplomat_alloc', isLeaf: true)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Void> _diplomat_alloc(int len, int align);

@_DiplomatFfiUse('diplomat_free')
@ffi.Native<ffi.Size Function(ffi.Pointer<ffi.Void>, ffi.Size, ffi.Size)>(symbol: 'diplomat_free', isLeaf: true)
// ignore: non_constant_identifier_names
external int _diplomat_free(ffi.Pointer<ffi.Void> ptr, int len, int align);


// ignore: unused_element
class _FinalizedArena {
  final ffi2.Arena arena;
  static final core.Finalizer<ffi2.Arena> _finalizer = core.Finalizer((arena) => arena.releaseAll());

  // ignore: unused_element
  _FinalizedArena() : arena = ffi2.Arena() {
    _finalizer.attach(this, arena);
  }

  // ignore: unused_element
  _FinalizedArena.withLifetime(core.List<core.List<Object>> lifetimeAppendArray) : arena = ffi2.Arena() {
    _finalizer.attach(this, arena);
    for (final edge in lifetimeAppendArray) {
      edge.add(this);
    }
  }
}


final class _ResultCyclicStructAFfiVoidUnion extends ffi.Union {
  external _CyclicStructAFfi ok;

}

final class _ResultCyclicStructAFfiVoid extends ffi.Struct {
  external _ResultCyclicStructAFfiVoidUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultCyclicStructAFfiVoid.ok(_CyclicStructAFfi val) {
    final struct = ffi.Struct.create<_ResultCyclicStructAFfiVoid>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultCyclicStructAFfiVoid.err() {
    final struct = ffi.Struct.create<_ResultCyclicStructAFfiVoid>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultDoubleVoidUnion extends ffi.Union {
  @ffi.Double()
  external double ok;

}

final class _ResultDoubleVoid extends ffi.Struct {
  external _ResultDoubleVoidUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultDoubleVoid.ok(double val) {
    final struct = ffi.Struct.create<_ResultDoubleVoid>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultDoubleVoid.err() {
    final struct = ffi.Struct.create<_ResultDoubleVoid>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultInt32OpaqueUnion extends ffi.Union {
  @ffi.Int32()
  external int ok;

  external ffi.Pointer<ffi.Opaque> err;
}

final class _ResultInt32Opaque extends ffi.Struct {
  external _ResultInt32OpaqueUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultInt32Opaque.ok(int val) {
    final struct = ffi.Struct.create<_ResultInt32Opaque>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultInt32Opaque.err(ffi.Pointer<ffi.Opaque> val) {
    final struct = ffi.Struct.create<_ResultInt32Opaque>();
    struct.isOk = false;
    struct.union.err = val;
    return struct;
  }
}


final class _ResultInt32VoidUnion extends ffi.Union {
  @ffi.Int32()
  external int ok;

}

final class _ResultInt32Void extends ffi.Struct {
  external _ResultInt32VoidUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultInt32Void.ok(int val) {
    final struct = ffi.Struct.create<_ResultInt32Void>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultInt32Void.err() {
    final struct = ffi.Struct.create<_ResultInt32Void>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultIntPtrVoidUnion extends ffi.Union {
  @ffi.IntPtr()
  external int ok;

}

final class _ResultIntPtrVoid extends ffi.Struct {
  external _ResultIntPtrVoidUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultIntPtrVoid.ok(int val) {
    final struct = ffi.Struct.create<_ResultIntPtrVoid>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultIntPtrVoid.err() {
    final struct = ffi.Struct.create<_ResultIntPtrVoid>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultMyStructFfiVoidUnion extends ffi.Union {
  external _MyStructFfi ok;

}

final class _ResultMyStructFfiVoid extends ffi.Struct {
  external _ResultMyStructFfiVoidUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultMyStructFfiVoid.ok(_MyStructFfi val) {
    final struct = ffi.Struct.create<_ResultMyStructFfiVoid>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultMyStructFfiVoid.err() {
    final struct = ffi.Struct.create<_ResultMyStructFfiVoid>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultOpaqueErrorStructFfiUnion extends ffi.Union {
  external ffi.Pointer<ffi.Opaque> ok;

  external _ErrorStructFfi err;
}

final class _ResultOpaqueErrorStructFfi extends ffi.Struct {
  external _ResultOpaqueErrorStructFfiUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultOpaqueErrorStructFfi.ok(ffi.Pointer<ffi.Opaque> val) {
    final struct = ffi.Struct.create<_ResultOpaqueErrorStructFfi>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultOpaqueErrorStructFfi.err(_ErrorStructFfi val) {
    final struct = ffi.Struct.create<_ResultOpaqueErrorStructFfi>();
    struct.isOk = false;
    struct.union.err = val;
    return struct;
  }
}


final class _ResultOpaqueInt32Union extends ffi.Union {
  external ffi.Pointer<ffi.Opaque> ok;

  @ffi.Int32()
  external int err;
}

final class _ResultOpaqueInt32 extends ffi.Struct {
  external _ResultOpaqueInt32Union union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultOpaqueInt32.ok(ffi.Pointer<ffi.Opaque> val) {
    final struct = ffi.Struct.create<_ResultOpaqueInt32>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultOpaqueInt32.err(int val) {
    final struct = ffi.Struct.create<_ResultOpaqueInt32>();
    struct.isOk = false;
    struct.union.err = val;
    return struct;
  }
}


final class _ResultOpaqueVoidUnion extends ffi.Union {
  external ffi.Pointer<ffi.Opaque> ok;

}

final class _ResultOpaqueVoid extends ffi.Struct {
  external _ResultOpaqueVoidUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultOpaqueVoid.ok(ffi.Pointer<ffi.Opaque> val) {
    final struct = ffi.Struct.create<_ResultOpaqueVoid>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultOpaqueVoid.err() {
    final struct = ffi.Struct.create<_ResultOpaqueVoid>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultOptionInputStructFfiVoidUnion extends ffi.Union {
  external _OptionInputStructFfi ok;

}

final class _ResultOptionInputStructFfiVoid extends ffi.Struct {
  external _ResultOptionInputStructFfiVoidUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultOptionInputStructFfiVoid.ok(_OptionInputStructFfi val) {
    final struct = ffi.Struct.create<_ResultOptionInputStructFfiVoid>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultOptionInputStructFfiVoid.err() {
    final struct = ffi.Struct.create<_ResultOptionInputStructFfiVoid>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultOptionStructFfiVoidUnion extends ffi.Union {
  external _OptionStructFfi ok;

}

final class _ResultOptionStructFfiVoid extends ffi.Struct {
  external _ResultOptionStructFfiVoidUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultOptionStructFfiVoid.ok(_OptionStructFfi val) {
    final struct = ffi.Struct.create<_ResultOptionStructFfiVoid>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultOptionStructFfiVoid.err() {
    final struct = ffi.Struct.create<_ResultOptionStructFfiVoid>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultSizeVoidUnion extends ffi.Union {
  @ffi.Size()
  external int ok;

}

final class _ResultSizeVoid extends ffi.Struct {
  external _ResultSizeVoidUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultSizeVoid.ok(int val) {
    final struct = ffi.Struct.create<_ResultSizeVoid>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultSizeVoid.err() {
    final struct = ffi.Struct.create<_ResultSizeVoid>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultSliceUtf8VoidUnion extends ffi.Union {
  external _SliceUtf8 ok;

}

final class _ResultSliceUtf8Void extends ffi.Struct {
  external _ResultSliceUtf8VoidUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultSliceUtf8Void.ok(_SliceUtf8 val) {
    final struct = ffi.Struct.create<_ResultSliceUtf8Void>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultSliceUtf8Void.err() {
    final struct = ffi.Struct.create<_ResultSliceUtf8Void>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultUint32VoidUnion extends ffi.Union {
  @ffi.Uint32()
  external Rune ok;

}

final class _ResultUint32Void extends ffi.Struct {
  external _ResultUint32VoidUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultUint32Void.ok(Rune val) {
    final struct = ffi.Struct.create<_ResultUint32Void>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultUint32Void.err() {
    final struct = ffi.Struct.create<_ResultUint32Void>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultUint8VoidUnion extends ffi.Union {
  @ffi.Uint8()
  external int ok;

}

final class _ResultUint8Void extends ffi.Struct {
  external _ResultUint8VoidUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultUint8Void.ok(int val) {
    final struct = ffi.Struct.create<_ResultUint8Void>();
    struct.isOk = true;
    struct.union.ok = val;
    return struct;
  }
  // ignore: unused_element
  factory _ResultUint8Void.err() {
    final struct = ffi.Struct.create<_ResultUint8Void>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultVoidMyZstFfi extends ffi.Struct {
  

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultVoidMyZstFfi.ok() {
    final struct = ffi.Struct.create<_ResultVoidMyZstFfi>();
    struct.isOk = true;
    return struct;
  }
  // ignore: unused_element
  factory _ResultVoidMyZstFfi.err() {
    final struct = ffi.Struct.create<_ResultVoidMyZstFfi>();
    struct.isOk = false;
    return struct;
  }
}


final class _ResultVoidOpaqueUnion extends ffi.Union {

  external ffi.Pointer<ffi.Opaque> err;
}

final class _ResultVoidOpaque extends ffi.Struct {
  external _ResultVoidOpaqueUnion union;

  @ffi.Bool()
  external bool isOk;

  // ignore: unused_element
  factory _ResultVoidOpaque.ok() {
    final struct = ffi.Struct.create<_ResultVoidOpaque>();
    struct.isOk = true;
    return struct;
  }
  // ignore: unused_element
  factory _ResultVoidOpaque.err(ffi.Pointer<ffi.Opaque> val) {
    final struct = ffi.Struct.create<_ResultVoidOpaque>();
    struct.isOk = false;
    struct.union.err = val;
    return struct;
  }
}


final class _SliceBool extends ffi.Struct {
  external ffi.Pointer<ffi.Bool> _data;

  @ffi.Size()
  external int _length;

  // This is expensive
  @override
  bool operator ==(Object other) {
    if (other is! _SliceBool || other._length != _length) {
      return false;
    }

    for (var i = 0; i < _length; i++) {
      if (other._data[i] != _data[i]) {
        return false;
      }
    }
    return true;
  }

  // This is cheap
  @override
  int get hashCode => _length.hashCode;

  // ignore: unused_element
  core.List<bool> _toDart(core.List<Object> lifetimeEdges, {bool isStatic = false}) {
    final r = core.Iterable.generate(_length).map((i) => _data[i]).toList(growable: false);
    if (lifetimeEdges.isEmpty && !isStatic) {
      _rustFree.attach(r, (pointer: _data.cast(), bytes: _length, align: 1));
    } else {
      _nopFree.attach(r, lifetimeEdges); // Keep lifetime edges alive
    }
    return r;
  }
}

extension on core.List<bool> {
  // ignore: unused_element
  _SliceBool _boolAllocIn(ffi.Allocator alloc) {
    final slice = ffi.Struct.create<_SliceBool>();
    slice._data = alloc(length);
    for (var i = 0; i < length; i++) {
      slice._data[i] = this[i];
    }
    slice._length = length;
    return slice;
  }
}


final class _SliceDouble extends ffi.Struct {
  external ffi.Pointer<ffi.Double> _data;

  @ffi.Size()
  external int _length;

  // This is expensive
  @override
  bool operator ==(Object other) {
    if (other is! _SliceDouble || other._length != _length) {
      return false;
    }

    for (var i = 0; i < _length; i++) {
      if (other._data[i] != _data[i]) {
        return false;
      }
    }
    return true;
  }

  // This is cheap
  @override
  int get hashCode => _length.hashCode;

  // ignore: unused_element
  core.List<double> _toDart(core.List<Object> lifetimeEdges, {bool isStatic = false}) {
    final r = _data.asTypedList(_length);
    if (lifetimeEdges.isEmpty && !isStatic) {
      _rustFree.attach(r, (pointer: _data.cast(), bytes: _length * 8, align: 8));
    } else {
      _nopFree.attach(r, lifetimeEdges); // Keep lifetime edges alive
    }
    return r;
  }
}

extension on core.List<double> {
  // ignore: unused_element
  _SliceDouble _float64AllocIn(ffi.Allocator alloc) {
    final slice = ffi.Struct.create<_SliceDouble>();
    slice._data = alloc(length)..asTypedList(length).setRange(0, length, this);
    slice._length = length;
    return slice;
  }
}

final class _SliceFloat extends ffi.Struct {
  external ffi.Pointer<ffi.Float> _data;

  @ffi.Size()
  external int _length;

  // This is expensive
  @override
  bool operator ==(Object other) {
    if (other is! _SliceFloat || other._length != _length) {
      return false;
    }

    for (var i = 0; i < _length; i++) {
      if (other._data[i] != _data[i]) {
        return false;
      }
    }
    return true;
  }

  // This is cheap
  @override
  int get hashCode => _length.hashCode;

  // ignore: unused_element
  core.List<double> _toDart(core.List<Object> lifetimeEdges, {bool isStatic = false}) {
    final r = _data.asTypedList(_length);
    if (lifetimeEdges.isEmpty && !isStatic) {
      _rustFree.attach(r, (pointer: _data.cast(), bytes: _length * 4, align: 4));
    } else {
      _nopFree.attach(r, lifetimeEdges); // Keep lifetime edges alive
    }
    return r;
  }
}

extension on core.List<double> {
  // ignore: unused_element
  _SliceFloat _float32AllocIn(ffi.Allocator alloc) {
    final slice = ffi.Struct.create<_SliceFloat>();
    slice._data = alloc(length)..asTypedList(length).setRange(0, length, this);
    slice._length = length;
    return slice;
  }
}

final class _SliceInt16 extends ffi.Struct {
  external ffi.Pointer<ffi.Int16> _data;

  @ffi.Size()
  external int _length;

  // This is expensive
  @override
  bool operator ==(Object other) {
    if (other is! _SliceInt16 || other._length != _length) {
      return false;
    }

    for (var i = 0; i < _length; i++) {
      if (other._data[i] != _data[i]) {
        return false;
      }
    }
    return true;
  }

  // This is cheap
  @override
  int get hashCode => _length.hashCode;

  // ignore: unused_element
  core.List<int> _toDart(core.List<Object> lifetimeEdges, {bool isStatic = false}) {
    final r = _data.asTypedList(_length);
    if (lifetimeEdges.isEmpty && !isStatic) {
      _rustFree.attach(r, (pointer: _data.cast(), bytes: _length * 2, align: 2));
    } else {
      _nopFree.attach(r, lifetimeEdges); // Keep lifetime edges alive
    }
    return r;
  }
}

extension on core.List<int> {
  // ignore: unused_element
  _SliceInt16 _int16AllocIn(ffi.Allocator alloc) {
    final slice = ffi.Struct.create<_SliceInt16>();
    slice._data = alloc(length)..asTypedList(length).setRange(0, length, this);
    slice._length = length;
    return slice;
  }
}

final class _SliceInt32 extends ffi.Struct {
  external ffi.Pointer<ffi.Int32> _data;

  @ffi.Size()
  external int _length;

  // This is expensive
  @override
  bool operator ==(Object other) {
    if (other is! _SliceInt32 || other._length != _length) {
      return false;
    }

    for (var i = 0; i < _length; i++) {
      if (other._data[i] != _data[i]) {
        return false;
      }
    }
    return true;
  }

  // This is cheap
  @override
  int get hashCode => _length.hashCode;

  // ignore: unused_element
  core.List<int> _toDart(core.List<Object> lifetimeEdges, {bool isStatic = false}) {
    final r = _data.asTypedList(_length);
    if (lifetimeEdges.isEmpty && !isStatic) {
      _rustFree.attach(r, (pointer: _data.cast(), bytes: _length * 4, align: 4));
    } else {
      _nopFree.attach(r, lifetimeEdges); // Keep lifetime edges alive
    }
    return r;
  }
}

extension on core.List<int> {
  // ignore: unused_element
  _SliceInt32 _int32AllocIn(ffi.Allocator alloc) {
    final slice = ffi.Struct.create<_SliceInt32>();
    slice._data = alloc(length)..asTypedList(length).setRange(0, length, this);
    slice._length = length;
    return slice;
  }
}

final class _SliceIsize extends ffi.Struct {
  external ffi.Pointer<ffi.IntPtr> _data;

  @ffi.Size()
  external int _length;

  // This is expensive
  @override
  bool operator ==(Object other) {
    if (other is! _SliceIsize || other._length != _length) {
      return false;
    }

    for (var i = 0; i < _length; i++) {
      if (other._data[i] != _data[i]) {
        return false;
      }
    }
    return true;
  }

  // This is cheap
  @override
  int get hashCode => _length.hashCode;

  // ignore: unused_element
  core.List<int> _toDart(core.List<Object> lifetimeEdges, {bool isStatic = false}) {
    final r = core.Iterable.generate(_length).map((i) => _data[i]).toList(growable: false);
    if (lifetimeEdges.isEmpty && !isStatic) {
      _diplomat_free(_data.cast(), _length * ffi.sizeOf<ffi.Size>(), ffi.sizeOf<ffi.Size>());
    } else {
      // Lifetime edges will be cleaned up
    }
    return r;
  }
}

extension on core.List<int> {
  // ignore: unused_element
  _SliceIsize _isizeAllocIn(ffi.Allocator alloc) {
    final slice = ffi.Struct.create<_SliceIsize>();
    slice._data = alloc(length);
    for (var i = 0; i < length; i++) {
      slice._data[i] = this[i];
    }
    slice._length = length;
    return slice;
  }
}


final class _SliceSliceUtf8 extends ffi.Struct {
  external ffi.Pointer<_SliceUtf8> _data;

  @ffi.Size()
  external int _length;

  // This is expensive
  @override
  bool operator ==(Object other) {
    if (other is! _SliceSliceUtf8 || other._length != _length) {
      return false;
    }

    for (var i = 0; i < _length; i++) {
      if (other._data[i] != _data[i]) {
        return false;
      }
    }
    return true;
  }

  // This is cheap
  @override
  int get hashCode => _length.hashCode;

  // ignore: unused_element
  core.List<core.String> _toDart(core.List<Object> lifetimeEdges, {bool isStatic = false}) {
    final r = core.Iterable.generate(_length).map((i) => _data[i]._toDart(lifetimeEdges)).toList(growable: false);
    if (lifetimeEdges.isEmpty && !isStatic) {
      // unsupported
    } else {
      // Lifetime edges will be cleaned up
    }
    return r;
  }
}

extension on core.List<core.String> {
  // ignore: unused_element
  _SliceSliceUtf8 _utf8SliceAllocIn(ffi.Allocator alloc) {
    final slice = ffi.Struct.create<_SliceSliceUtf8>();
    slice._data = alloc(length);
    for (var i = 0; i < length; i++) {
      slice._data[i] = this[i]._utf8AllocIn(alloc);
    }
    slice._length = length;
    return slice;
  }
}


final class _SliceUint16 extends ffi.Struct {
  external ffi.Pointer<ffi.Uint16> _data;

  @ffi.Size()
  external int _length;

  // This is expensive
  @override
  bool operator ==(Object other) {
    if (other is! _SliceUint16 || other._length != _length) {
      return false;
    }

    for (var i = 0; i < _length; i++) {
      if (other._data[i] != _data[i]) {
        return false;
      }
    }
    return true;
  }

  // This is cheap
  @override
  int get hashCode => _length.hashCode;

  // ignore: unused_element
  core.List<int> _toDart(core.List<Object> lifetimeEdges, {bool isStatic = false}) {
    final r = _data.asTypedList(_length);
    if (lifetimeEdges.isEmpty && !isStatic) {
      _rustFree.attach(r, (pointer: _data.cast(), bytes: _length * 2, align: 2));
    } else {
      _nopFree.attach(r, lifetimeEdges); // Keep lifetime edges alive
    }
    return r;
  }
}

extension on core.List<int> {
  // ignore: unused_element
  _SliceUint16 _uint16AllocIn(ffi.Allocator alloc) {
    final slice = ffi.Struct.create<_SliceUint16>();
    slice._data = alloc(length);
    for (var i = 0; i < length; i++) {
      slice._data[i] = this[i].clamp(0, 65535);
    }
    slice._length = length;
    return slice;
  }
}


final class _SliceUint8 extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> _data;

  @ffi.Size()
  external int _length;

  // This is expensive
  @override
  bool operator ==(Object other) {
    if (other is! _SliceUint8 || other._length != _length) {
      return false;
    }

    for (var i = 0; i < _length; i++) {
      if (other._data[i] != _data[i]) {
        return false;
      }
    }
    return true;
  }

  // This is cheap
  @override
  int get hashCode => _length.hashCode;

  // ignore: unused_element
  core.List<int> _toDart(core.List<Object> lifetimeEdges, {bool isStatic = false}) {
    final r = _data.asTypedList(_length);
    if (lifetimeEdges.isEmpty && !isStatic) {
      _rustFree.attach(r, (pointer: _data.cast(), bytes: _length, align: 1));
    } else {
      _nopFree.attach(r, lifetimeEdges); // Keep lifetime edges alive
    }
    return r;
  }
}

extension on core.List<int> {
  // ignore: unused_element
  _SliceUint8 _uint8AllocIn(ffi.Allocator alloc) {
    final slice = ffi.Struct.create<_SliceUint8>();
    slice._data = alloc(length);
    for (var i = 0; i < length; i++) {
      slice._data[i] = this[i].clamp(0, 255);
    }
    slice._length = length;
    return slice;
  }
}


final class _SliceUsize extends ffi.Struct {
  external ffi.Pointer<ffi.Size> _data;

  @ffi.Size()
  external int _length;

  // This is expensive
  @override
  bool operator ==(Object other) {
    if (other is! _SliceUsize || other._length != _length) {
      return false;
    }

    for (var i = 0; i < _length; i++) {
      if (other._data[i] != _data[i]) {
        return false;
      }
    }
    return true;
  }

  // This is cheap
  @override
  int get hashCode => _length.hashCode;

  // ignore: unused_element
  core.List<int> _toDart(core.List<Object> lifetimeEdges, {bool isStatic = false}) {
    final r = core.Iterable.generate(_length).map((i) => _data[i]).toList(growable: false);
    if (lifetimeEdges.isEmpty && !isStatic) {
      _diplomat_free(_data.cast(), _length * ffi.sizeOf<ffi.Size>(), ffi.sizeOf<ffi.Size>());
    } else {
      // Lifetime edges will be cleaned up
    }
    return r;
  }
}

extension on core.List<int> {
  // ignore: unused_element
  _SliceUsize _usizeAllocIn(ffi.Allocator alloc) {
    final slice = ffi.Struct.create<_SliceUsize>();
    slice._data = alloc(length);
    for (var i = 0; i < length; i++) {
      slice._data[i] = this[i] < 0 ? 0 : this[i];
    }
    slice._length = length;
    return slice;
  }
}


final class _SliceUtf16 extends ffi.Struct {
  external ffi.Pointer<ffi.Uint16> _data;

  @ffi.Size()
  external int _length;

  // This is expensive
  @override
  bool operator ==(Object other) {
    if (other is! _SliceUtf16 || other._length != _length) {
      return false;
    }

    for (var i = 0; i < _length; i++) {
      if (other._data[i] != _data[i]) {
        return false;
      }
    }
    return true;
  }

  // This is cheap
  @override
  int get hashCode => _length.hashCode;

  // ignore: unused_element
  String _toDart(core.List<Object> lifetimeEdges, {bool isStatic = false}) {
    final r = core.String.fromCharCodes(_data.asTypedList(_length));
    if (lifetimeEdges.isEmpty && !isStatic) {
      _diplomat_free(_data.cast(), _length * 2, 2);
    } else {
      // Lifetime edges will be cleaned up
    }
    return r;
  }
}

extension on String {
  // ignore: unused_element
  _SliceUtf16 _utf16AllocIn(ffi.Allocator alloc) {
    final slice = ffi.Struct.create<_SliceUtf16>();
    slice._data = alloc(codeUnits.length)..asTypedList(codeUnits.length).setRange(0, codeUnits.length, codeUnits);
    slice._length = length;
    return slice;
  }
}


final class _SliceUtf8 extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> _data;

  @ffi.Size()
  external int _length;

  // This is expensive
  @override
  bool operator ==(Object other) {
    if (other is! _SliceUtf8 || other._length != _length) {
      return false;
    }

    for (var i = 0; i < _length; i++) {
      if (other._data[i] != _data[i]) {
        return false;
      }
    }
    return true;
  }

  // This is cheap
  @override
  int get hashCode => _length.hashCode;

  // ignore: unused_element
  String _toDart(core.List<Object> lifetimeEdges, {bool isStatic = false}) {
    final r = Utf8Decoder().convert(_data.asTypedList(_length));
    if (lifetimeEdges.isEmpty && !isStatic) {
      _diplomat_free(_data.cast(), _length, 1);
    } else {
      // Lifetime edges will be cleaned up
    }
    return r;
  }
}

extension on String {
  // ignore: unused_element
  _SliceUtf8 _utf8AllocIn(ffi.Allocator alloc) {
    final slice = ffi.Struct.create<_SliceUtf8>();
    final encoded = Utf8Encoder().convert(this);
    slice._data = alloc(encoded.length)..asTypedList(encoded.length).setRange(0, encoded.length, encoded);
    slice._length = encoded.length;
    return slice;
  }
}


final class _Write {
  final ffi.Pointer<ffi.Opaque> _ffi;

  _Write() : _ffi = _diplomat_buffer_write_create(0);
  
  String finalize() {
    try {
      final buf = _diplomat_buffer_write_get_bytes(_ffi);
      if (buf == ffi.Pointer.fromAddress(0)) {
        throw core.OutOfMemoryError();
      }
      return Utf8Decoder().convert(buf.asTypedList(_diplomat_buffer_write_len(_ffi)));
    } finally {
      _diplomat_buffer_write_destroy(_ffi);
    }
  }
}

@_DiplomatFfiUse('diplomat_buffer_write_create')
@ffi.Native<ffi.Pointer<ffi.Opaque> Function(ffi.Size)>(symbol: 'diplomat_buffer_write_create', isLeaf: true)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Opaque> _diplomat_buffer_write_create(int len);

@_DiplomatFfiUse('diplomat_buffer_write_len')
@ffi.Native<ffi.Size Function(ffi.Pointer<ffi.Opaque>)>(symbol: 'diplomat_buffer_write_len', isLeaf: true)
// ignore: non_constant_identifier_names
external int _diplomat_buffer_write_len(ffi.Pointer<ffi.Opaque> ptr);

@_DiplomatFfiUse('diplomat_buffer_write_get_bytes')
@ffi.Native<ffi.Pointer<ffi.Uint8> Function(ffi.Pointer<ffi.Opaque>)>(symbol: 'diplomat_buffer_write_get_bytes', isLeaf: true)
// ignore: non_constant_identifier_names
external ffi.Pointer<ffi.Uint8> _diplomat_buffer_write_get_bytes(ffi.Pointer<ffi.Opaque> ptr);

@_DiplomatFfiUse('diplomat_buffer_write_destroy')
@ffi.Native<ffi.Void Function(ffi.Pointer<ffi.Opaque>)>(symbol: 'diplomat_buffer_write_destroy', isLeaf: true)
// ignore: non_constant_identifier_names
external void _diplomat_buffer_write_destroy(ffi.Pointer<ffi.Opaque> ptr);

// dart format on

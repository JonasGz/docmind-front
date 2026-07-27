// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Document {

 String get id; String get filename;/// Serializado com `unknownEnumValue` para que um status novo no backend
/// não lance exceção no parse.
@JsonKey(unknownEnumValue: DocumentStatus.unknown) DocumentStatus get status; String? get title;@JsonKey(unknownEnumValue: DocumentType.unknown) DocumentType? get docType;/// Classificação original em texto livre, quando `docType` é `outro`.
 String? get rawDocType;/// Números de lei, processo, súmula extraídos do documento.
 List<String>? get identifiers; int? get pageCount; int? get chunkCount;/// Preenchido apenas quando `status` é `failed`.
 String? get errorMessage; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentCopyWith<Document> get copyWith => _$DocumentCopyWithImpl<Document>(this as Document, _$identity);

  /// Serializes this Document to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Document&&(identical(other.id, id) || other.id == id)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.docType, docType) || other.docType == docType)&&(identical(other.rawDocType, rawDocType) || other.rawDocType == rawDocType)&&const DeepCollectionEquality().equals(other.identifiers, identifiers)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.chunkCount, chunkCount) || other.chunkCount == chunkCount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,filename,status,title,docType,rawDocType,const DeepCollectionEquality().hash(identifiers),pageCount,chunkCount,errorMessage,createdAt,updatedAt);

@override
String toString() {
  return 'Document(id: $id, filename: $filename, status: $status, title: $title, docType: $docType, rawDocType: $rawDocType, identifiers: $identifiers, pageCount: $pageCount, chunkCount: $chunkCount, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DocumentCopyWith<$Res>  {
  factory $DocumentCopyWith(Document value, $Res Function(Document) _then) = _$DocumentCopyWithImpl;
@useResult
$Res call({
 String id, String filename,@JsonKey(unknownEnumValue: DocumentStatus.unknown) DocumentStatus status, String? title,@JsonKey(unknownEnumValue: DocumentType.unknown) DocumentType? docType, String? rawDocType, List<String>? identifiers, int? pageCount, int? chunkCount, String? errorMessage, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$DocumentCopyWithImpl<$Res>
    implements $DocumentCopyWith<$Res> {
  _$DocumentCopyWithImpl(this._self, this._then);

  final Document _self;
  final $Res Function(Document) _then;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? filename = null,Object? status = null,Object? title = freezed,Object? docType = freezed,Object? rawDocType = freezed,Object? identifiers = freezed,Object? pageCount = freezed,Object? chunkCount = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DocumentStatus,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,docType: freezed == docType ? _self.docType : docType // ignore: cast_nullable_to_non_nullable
as DocumentType?,rawDocType: freezed == rawDocType ? _self.rawDocType : rawDocType // ignore: cast_nullable_to_non_nullable
as String?,identifiers: freezed == identifiers ? _self.identifiers : identifiers // ignore: cast_nullable_to_non_nullable
as List<String>?,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,chunkCount: freezed == chunkCount ? _self.chunkCount : chunkCount // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Document].
extension DocumentPatterns on Document {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Document value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Document value)  $default,){
final _that = this;
switch (_that) {
case _Document():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Document value)?  $default,){
final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String filename, @JsonKey(unknownEnumValue: DocumentStatus.unknown)  DocumentStatus status,  String? title, @JsonKey(unknownEnumValue: DocumentType.unknown)  DocumentType? docType,  String? rawDocType,  List<String>? identifiers,  int? pageCount,  int? chunkCount,  String? errorMessage,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that.id,_that.filename,_that.status,_that.title,_that.docType,_that.rawDocType,_that.identifiers,_that.pageCount,_that.chunkCount,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String filename, @JsonKey(unknownEnumValue: DocumentStatus.unknown)  DocumentStatus status,  String? title, @JsonKey(unknownEnumValue: DocumentType.unknown)  DocumentType? docType,  String? rawDocType,  List<String>? identifiers,  int? pageCount,  int? chunkCount,  String? errorMessage,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Document():
return $default(_that.id,_that.filename,_that.status,_that.title,_that.docType,_that.rawDocType,_that.identifiers,_that.pageCount,_that.chunkCount,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String filename, @JsonKey(unknownEnumValue: DocumentStatus.unknown)  DocumentStatus status,  String? title, @JsonKey(unknownEnumValue: DocumentType.unknown)  DocumentType? docType,  String? rawDocType,  List<String>? identifiers,  int? pageCount,  int? chunkCount,  String? errorMessage,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that.id,_that.filename,_that.status,_that.title,_that.docType,_that.rawDocType,_that.identifiers,_that.pageCount,_that.chunkCount,_that.errorMessage,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Document extends Document {
  const _Document({required this.id, required this.filename, @JsonKey(unknownEnumValue: DocumentStatus.unknown) required this.status, required this.title, @JsonKey(unknownEnumValue: DocumentType.unknown) required this.docType, required this.rawDocType, required final  List<String>? identifiers, required this.pageCount, required this.chunkCount, required this.errorMessage, required this.createdAt, required this.updatedAt}): _identifiers = identifiers,super._();
  factory _Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);

@override final  String id;
@override final  String filename;
/// Serializado com `unknownEnumValue` para que um status novo no backend
/// não lance exceção no parse.
@override@JsonKey(unknownEnumValue: DocumentStatus.unknown) final  DocumentStatus status;
@override final  String? title;
@override@JsonKey(unknownEnumValue: DocumentType.unknown) final  DocumentType? docType;
/// Classificação original em texto livre, quando `docType` é `outro`.
@override final  String? rawDocType;
/// Números de lei, processo, súmula extraídos do documento.
 final  List<String>? _identifiers;
/// Números de lei, processo, súmula extraídos do documento.
@override List<String>? get identifiers {
  final value = _identifiers;
  if (value == null) return null;
  if (_identifiers is EqualUnmodifiableListView) return _identifiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? pageCount;
@override final  int? chunkCount;
/// Preenchido apenas quando `status` é `failed`.
@override final  String? errorMessage;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentCopyWith<_Document> get copyWith => __$DocumentCopyWithImpl<_Document>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Document&&(identical(other.id, id) || other.id == id)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.status, status) || other.status == status)&&(identical(other.title, title) || other.title == title)&&(identical(other.docType, docType) || other.docType == docType)&&(identical(other.rawDocType, rawDocType) || other.rawDocType == rawDocType)&&const DeepCollectionEquality().equals(other._identifiers, _identifiers)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount)&&(identical(other.chunkCount, chunkCount) || other.chunkCount == chunkCount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,filename,status,title,docType,rawDocType,const DeepCollectionEquality().hash(_identifiers),pageCount,chunkCount,errorMessage,createdAt,updatedAt);

@override
String toString() {
  return 'Document(id: $id, filename: $filename, status: $status, title: $title, docType: $docType, rawDocType: $rawDocType, identifiers: $identifiers, pageCount: $pageCount, chunkCount: $chunkCount, errorMessage: $errorMessage, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DocumentCopyWith<$Res> implements $DocumentCopyWith<$Res> {
  factory _$DocumentCopyWith(_Document value, $Res Function(_Document) _then) = __$DocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, String filename,@JsonKey(unknownEnumValue: DocumentStatus.unknown) DocumentStatus status, String? title,@JsonKey(unknownEnumValue: DocumentType.unknown) DocumentType? docType, String? rawDocType, List<String>? identifiers, int? pageCount, int? chunkCount, String? errorMessage, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$DocumentCopyWithImpl<$Res>
    implements _$DocumentCopyWith<$Res> {
  __$DocumentCopyWithImpl(this._self, this._then);

  final _Document _self;
  final $Res Function(_Document) _then;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? filename = null,Object? status = null,Object? title = freezed,Object? docType = freezed,Object? rawDocType = freezed,Object? identifiers = freezed,Object? pageCount = freezed,Object? chunkCount = freezed,Object? errorMessage = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Document(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DocumentStatus,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,docType: freezed == docType ? _self.docType : docType // ignore: cast_nullable_to_non_nullable
as DocumentType?,rawDocType: freezed == rawDocType ? _self.rawDocType : rawDocType // ignore: cast_nullable_to_non_nullable
as String?,identifiers: freezed == identifiers ? _self._identifiers : identifiers // ignore: cast_nullable_to_non_nullable
as List<String>?,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,chunkCount: freezed == chunkCount ? _self.chunkCount : chunkCount // ignore: cast_nullable_to_non_nullable
as int?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

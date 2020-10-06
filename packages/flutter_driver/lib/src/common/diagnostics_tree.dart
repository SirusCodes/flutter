// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'enum_util.dart';
import 'find.dart';
import 'message.dart';

/// [DiagnosticsNode] tree types that can be requested by [GetDiagnosticsTree].
enum DiagnosticsType {
  /// The [DiagnosticsNode] tree formed by [RenderObject]s.
  renderObject,

  /// The [DiagnosticsNode] tree formed by [Widget]s.
  widget,
}

EnumIndex<DiagnosticsType> _diagnosticsTypeIndex = EnumIndex<DiagnosticsType>(DiagnosticsType.values);

/// A Flutter Driver command to retrieve the JSON-serialized [DiagnosticsNode]
/// tree of the object identified by [finder].
///
/// The [DiagnosticsType] of the [DiagnosticsNode] tree returned is specified by
/// [diagnosticsType].
class GetDiagnosticsTree extends CommandWithTarget {
  /// Creates a [GetDiagnosticsTree] Flutter Driver command.
  GetDiagnosticsTree(SerializableFinder finder, this.diagnosticsType, {
    this.subtreeDepth = 0,
    this.includeProperties = true,
    Duration? timeout,
  }) : assert(subtreeDepth != null),
       assert(includeProperties != null),
       super(finder, timeout: timeout);

  /// Deserializes this command from the value generated by [serialize].
  GetDiagnosticsTree.deserialize(Map<String, String> json, DeserializeFinderFactory finderFactory)
      : subtreeDepth = int.parse(json['subtreeDepth']!),
        includeProperties = json['includeProperties'] == 'true',
        diagnosticsType = _diagnosticsTypeIndex.lookupBySimpleName(json['diagnosticsType']!),
        super.deserialize(json, finderFactory);

  /// How many levels of children to include in the JSON result.
  ///
  /// Defaults to zero, which will only return the [DiagnosticsNode] information
  /// of the object identified by [finder].
  final int subtreeDepth;

  /// Whether the properties of a [DiagnosticsNode] should be included.
  final bool includeProperties;

  /// The type of [DiagnosticsNode] tree that is requested.
  final DiagnosticsType diagnosticsType;

  @override
  Map<String, String> serialize() => super.serialize()..addAll(<String, String>{
    'subtreeDepth': subtreeDepth.toString(),
    'includeProperties': includeProperties.toString(),
    'diagnosticsType': _diagnosticsTypeIndex.toSimpleName(diagnosticsType),
  });

  @override
  String get kind => 'get_diagnostics_tree';
}

/// The result of a [GetDiagnosticsTree] command.
class DiagnosticsTreeResult extends Result {
  /// Creates a [DiagnosticsTreeResult].
  const DiagnosticsTreeResult(this.json);

  /// The JSON encoded [DiagnosticsNode] tree requested by the
  /// [GetDiagnosticsTree] command.
  final Map<String, dynamic> json;

  @override
  Map<String, dynamic> toJson() => json;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_result.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGameResultCollection on Isar {
  IsarCollection<GameResult> get gameResults => this.collection();
}

const GameResultSchema = CollectionSchema(
  name: r'GameResult',
  id: 9132494934183461079,
  properties: {
    r'durationInSeconds': PropertySchema(
      id: 0,
      name: r'durationInSeconds',
      type: IsarType.long,
    ),
    r'gridSize': PropertySchema(id: 1, name: r'gridSize', type: IsarType.long),
    r'moveCount': PropertySchema(
      id: 2,
      name: r'moveCount',
      type: IsarType.long,
    ),
    r'playedAt': PropertySchema(
      id: 3,
      name: r'playedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _gameResultEstimateSize,
  serialize: _gameResultSerialize,
  deserialize: _gameResultDeserialize,
  deserializeProp: _gameResultDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _gameResultGetId,
  getLinks: _gameResultGetLinks,
  attach: _gameResultAttach,
  version: '3.3.2',
);

int _gameResultEstimateSize(
  GameResult object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _gameResultSerialize(
  GameResult object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationInSeconds);
  writer.writeLong(offsets[1], object.gridSize);
  writer.writeLong(offsets[2], object.moveCount);
  writer.writeDateTime(offsets[3], object.playedAt);
}

GameResult _gameResultDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GameResult(
    durationInSeconds: reader.readLong(offsets[0]),
    gridSize: reader.readLong(offsets[1]),
    id: id,
    moveCount: reader.readLong(offsets[2]),
    playedAt: reader.readDateTime(offsets[3]),
  );
  return object;
}

P _gameResultDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gameResultGetId(GameResult object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gameResultGetLinks(GameResult object) {
  return [];
}

void _gameResultAttach(IsarCollection<dynamic> col, Id id, GameResult object) {
  object.id = id;
}

extension GameResultQueryWhereSort
    on QueryBuilder<GameResult, GameResult, QWhere> {
  QueryBuilder<GameResult, GameResult, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GameResultQueryWhere
    on QueryBuilder<GameResult, GameResult, QWhereClause> {
  QueryBuilder<GameResult, GameResult, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension GameResultQueryFilter
    on QueryBuilder<GameResult, GameResult, QFilterCondition> {
  QueryBuilder<GameResult, GameResult, QAfterFilterCondition>
  durationInSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationInSeconds', value: value),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition>
  durationInSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'durationInSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition>
  durationInSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'durationInSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition>
  durationInSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'durationInSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> gridSizeEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gridSize', value: value),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition>
  gridSizeGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'gridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> gridSizeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'gridSize',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> gridSizeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'gridSize',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> moveCountEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'moveCount', value: value),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition>
  moveCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'moveCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> moveCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'moveCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> moveCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'moveCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> playedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'playedAt', value: value),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition>
  playedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'playedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> playedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'playedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterFilterCondition> playedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'playedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension GameResultQueryObject
    on QueryBuilder<GameResult, GameResult, QFilterCondition> {}

extension GameResultQueryLinks
    on QueryBuilder<GameResult, GameResult, QFilterCondition> {}

extension GameResultQuerySortBy
    on QueryBuilder<GameResult, GameResult, QSortBy> {
  QueryBuilder<GameResult, GameResult, QAfterSortBy> sortByDurationInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.asc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy>
  sortByDurationInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.desc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> sortByGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSize', Sort.asc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> sortByGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSize', Sort.desc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> sortByMoveCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveCount', Sort.asc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> sortByMoveCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveCount', Sort.desc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> sortByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.asc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> sortByPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.desc);
    });
  }
}

extension GameResultQuerySortThenBy
    on QueryBuilder<GameResult, GameResult, QSortThenBy> {
  QueryBuilder<GameResult, GameResult, QAfterSortBy> thenByDurationInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.asc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy>
  thenByDurationInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.desc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> thenByGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSize', Sort.asc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> thenByGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSize', Sort.desc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> thenByMoveCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveCount', Sort.asc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> thenByMoveCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveCount', Sort.desc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> thenByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.asc);
    });
  }

  QueryBuilder<GameResult, GameResult, QAfterSortBy> thenByPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.desc);
    });
  }
}

extension GameResultQueryWhereDistinct
    on QueryBuilder<GameResult, GameResult, QDistinct> {
  QueryBuilder<GameResult, GameResult, QDistinct>
  distinctByDurationInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInSeconds');
    });
  }

  QueryBuilder<GameResult, GameResult, QDistinct> distinctByGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gridSize');
    });
  }

  QueryBuilder<GameResult, GameResult, QDistinct> distinctByMoveCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moveCount');
    });
  }

  QueryBuilder<GameResult, GameResult, QDistinct> distinctByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playedAt');
    });
  }
}

extension GameResultQueryProperty
    on QueryBuilder<GameResult, GameResult, QQueryProperty> {
  QueryBuilder<GameResult, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GameResult, int, QQueryOperations> durationInSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInSeconds');
    });
  }

  QueryBuilder<GameResult, int, QQueryOperations> gridSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gridSize');
    });
  }

  QueryBuilder<GameResult, int, QQueryOperations> moveCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moveCount');
    });
  }

  QueryBuilder<GameResult, DateTime, QQueryOperations> playedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playedAt');
    });
  }
}

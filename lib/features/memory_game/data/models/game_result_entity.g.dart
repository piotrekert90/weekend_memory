// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_result_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGameResultEntityCollection on Isar {
  IsarCollection<GameResultEntity> get gameResultEntitys => this.collection();
}

const GameResultEntitySchema = CollectionSchema(
  name: r'GameResultEntity',
  id: 2307060016069072233,
  properties: {
    r'durationInSeconds': PropertySchema(
      id: 0,
      name: r'durationInSeconds',
      type: IsarType.long,
    ),
    r'gameMode': PropertySchema(
      id: 1,
      name: r'gameMode',
      type: IsarType.byte,
      enumMap: _GameResultEntitygameModeEnumValueMap,
    ),
    r'gridSize': PropertySchema(id: 2, name: r'gridSize', type: IsarType.long),
    r'moveCount': PropertySchema(
      id: 3,
      name: r'moveCount',
      type: IsarType.long,
    ),
    r'playedAt': PropertySchema(
      id: 4,
      name: r'playedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _gameResultEntityEstimateSize,
  serialize: _gameResultEntitySerialize,
  deserialize: _gameResultEntityDeserialize,
  deserializeProp: _gameResultEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'durationInSeconds_moveCount': IndexSchema(
      id: -4841869170972988310,
      name: r'durationInSeconds_moveCount',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'durationInSeconds',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'moveCount',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'playedAt': IndexSchema(
      id: -3711549563919110219,
      name: r'playedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'playedAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _gameResultEntityGetId,
  getLinks: _gameResultEntityGetLinks,
  attach: _gameResultEntityAttach,
  version: '3.3.2',
);

int _gameResultEntityEstimateSize(
  GameResultEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _gameResultEntitySerialize(
  GameResultEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.durationInSeconds);
  writer.writeByte(offsets[1], object.gameMode.index);
  writer.writeLong(offsets[2], object.gridSize);
  writer.writeLong(offsets[3], object.moveCount);
  writer.writeDateTime(offsets[4], object.playedAt);
}

GameResultEntity _gameResultEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GameResultEntity(
    durationInSeconds: reader.readLong(offsets[0]),
    gameMode:
        _GameResultEntitygameModeValueEnumMap[reader.readByteOrNull(
          offsets[1],
        )] ??
        GameMode.classic,
    gridSize: reader.readLong(offsets[2]),
    id: id,
    moveCount: reader.readLong(offsets[3]),
    playedAt: reader.readDateTime(offsets[4]),
  );
  return object;
}

P _gameResultEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (_GameResultEntitygameModeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              GameMode.classic)
          as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _GameResultEntitygameModeEnumValueMap = {'classic': 0, 'countdown': 1};
const _GameResultEntitygameModeValueEnumMap = {
  0: GameMode.classic,
  1: GameMode.countdown,
};

Id _gameResultEntityGetId(GameResultEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gameResultEntityGetLinks(GameResultEntity object) {
  return [];
}

void _gameResultEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  GameResultEntity object,
) {
  object.id = id;
}

extension GameResultEntityQueryWhereSort
    on QueryBuilder<GameResultEntity, GameResultEntity, QWhere> {
  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhere>
  anyDurationInSecondsMoveCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'durationInSeconds_moveCount'),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhere> anyPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'playedAt'),
      );
    });
  }
}

extension GameResultEntityQueryWhere
    on QueryBuilder<GameResultEntity, GameResultEntity, QWhereClause> {
  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  durationInSecondsEqualToAnyMoveCount(int durationInSeconds) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'durationInSeconds_moveCount',
          value: [durationInSeconds],
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  durationInSecondsNotEqualToAnyMoveCount(int durationInSeconds) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'durationInSeconds_moveCount',
                lower: [],
                upper: [durationInSeconds],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'durationInSeconds_moveCount',
                lower: [durationInSeconds],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'durationInSeconds_moveCount',
                lower: [durationInSeconds],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'durationInSeconds_moveCount',
                lower: [],
                upper: [durationInSeconds],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  durationInSecondsGreaterThanAnyMoveCount(
    int durationInSeconds, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'durationInSeconds_moveCount',
          lower: [durationInSeconds],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  durationInSecondsLessThanAnyMoveCount(
    int durationInSeconds, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'durationInSeconds_moveCount',
          lower: [],
          upper: [durationInSeconds],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  durationInSecondsBetweenAnyMoveCount(
    int lowerDurationInSeconds,
    int upperDurationInSeconds, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'durationInSeconds_moveCount',
          lower: [lowerDurationInSeconds],
          includeLower: includeLower,
          upper: [upperDurationInSeconds],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  durationInSecondsMoveCountEqualTo(int durationInSeconds, int moveCount) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'durationInSeconds_moveCount',
          value: [durationInSeconds, moveCount],
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  durationInSecondsEqualToMoveCountNotEqualTo(
    int durationInSeconds,
    int moveCount,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'durationInSeconds_moveCount',
                lower: [durationInSeconds],
                upper: [durationInSeconds, moveCount],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'durationInSeconds_moveCount',
                lower: [durationInSeconds, moveCount],
                includeLower: false,
                upper: [durationInSeconds],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'durationInSeconds_moveCount',
                lower: [durationInSeconds, moveCount],
                includeLower: false,
                upper: [durationInSeconds],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'durationInSeconds_moveCount',
                lower: [durationInSeconds],
                upper: [durationInSeconds, moveCount],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  durationInSecondsEqualToMoveCountGreaterThan(
    int durationInSeconds,
    int moveCount, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'durationInSeconds_moveCount',
          lower: [durationInSeconds, moveCount],
          includeLower: include,
          upper: [durationInSeconds],
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  durationInSecondsEqualToMoveCountLessThan(
    int durationInSeconds,
    int moveCount, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'durationInSeconds_moveCount',
          lower: [durationInSeconds],
          upper: [durationInSeconds, moveCount],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  durationInSecondsEqualToMoveCountBetween(
    int durationInSeconds,
    int lowerMoveCount,
    int upperMoveCount, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'durationInSeconds_moveCount',
          lower: [durationInSeconds, lowerMoveCount],
          includeLower: includeLower,
          upper: [durationInSeconds, upperMoveCount],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  playedAtEqualTo(DateTime playedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'playedAt', value: [playedAt]),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  playedAtNotEqualTo(DateTime playedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'playedAt',
                lower: [],
                upper: [playedAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'playedAt',
                lower: [playedAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'playedAt',
                lower: [playedAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'playedAt',
                lower: [],
                upper: [playedAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  playedAtGreaterThan(DateTime playedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'playedAt',
          lower: [playedAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  playedAtLessThan(DateTime playedAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'playedAt',
          lower: [],
          upper: [playedAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterWhereClause>
  playedAtBetween(
    DateTime lowerPlayedAt,
    DateTime upperPlayedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'playedAt',
          lower: [lowerPlayedAt],
          includeLower: includeLower,
          upper: [upperPlayedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension GameResultEntityQueryFilter
    on QueryBuilder<GameResultEntity, GameResultEntity, QFilterCondition> {
  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  durationInSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationInSeconds', value: value),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  gameModeEqualTo(GameMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gameMode', value: value),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  gameModeGreaterThan(GameMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'gameMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  gameModeLessThan(GameMode value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'gameMode',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  gameModeBetween(
    GameMode lower,
    GameMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'gameMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  gridSizeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gridSize', value: value),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  gridSizeLessThan(int value, {bool include = false}) {
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  gridSizeBetween(
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  moveCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'moveCount', value: value),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  moveCountLessThan(int value, {bool include = false}) {
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  moveCountBetween(
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  playedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'playedAt', value: value),
      );
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  playedAtLessThan(DateTime value, {bool include = false}) {
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

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterFilterCondition>
  playedAtBetween(
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

extension GameResultEntityQueryObject
    on QueryBuilder<GameResultEntity, GameResultEntity, QFilterCondition> {}

extension GameResultEntityQueryLinks
    on QueryBuilder<GameResultEntity, GameResultEntity, QFilterCondition> {}

extension GameResultEntityQuerySortBy
    on QueryBuilder<GameResultEntity, GameResultEntity, QSortBy> {
  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  sortByDurationInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.asc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  sortByDurationInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.desc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  sortByGameMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameMode', Sort.asc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  sortByGameModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameMode', Sort.desc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  sortByGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSize', Sort.asc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  sortByGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSize', Sort.desc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  sortByMoveCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveCount', Sort.asc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  sortByMoveCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveCount', Sort.desc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  sortByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.asc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  sortByPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.desc);
    });
  }
}

extension GameResultEntityQuerySortThenBy
    on QueryBuilder<GameResultEntity, GameResultEntity, QSortThenBy> {
  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  thenByDurationInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.asc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  thenByDurationInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.desc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  thenByGameMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameMode', Sort.asc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  thenByGameModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gameMode', Sort.desc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  thenByGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSize', Sort.asc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  thenByGridSizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gridSize', Sort.desc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  thenByMoveCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveCount', Sort.asc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  thenByMoveCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moveCount', Sort.desc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  thenByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.asc);
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QAfterSortBy>
  thenByPlayedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'playedAt', Sort.desc);
    });
  }
}

extension GameResultEntityQueryWhereDistinct
    on QueryBuilder<GameResultEntity, GameResultEntity, QDistinct> {
  QueryBuilder<GameResultEntity, GameResultEntity, QDistinct>
  distinctByDurationInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInSeconds');
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QDistinct>
  distinctByGameMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gameMode');
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QDistinct>
  distinctByGridSize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'gridSize');
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QDistinct>
  distinctByMoveCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moveCount');
    });
  }

  QueryBuilder<GameResultEntity, GameResultEntity, QDistinct>
  distinctByPlayedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'playedAt');
    });
  }
}

extension GameResultEntityQueryProperty
    on QueryBuilder<GameResultEntity, GameResultEntity, QQueryProperty> {
  QueryBuilder<GameResultEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GameResultEntity, int, QQueryOperations>
  durationInSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInSeconds');
    });
  }

  QueryBuilder<GameResultEntity, GameMode, QQueryOperations>
  gameModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gameMode');
    });
  }

  QueryBuilder<GameResultEntity, int, QQueryOperations> gridSizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gridSize');
    });
  }

  QueryBuilder<GameResultEntity, int, QQueryOperations> moveCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moveCount');
    });
  }

  QueryBuilder<GameResultEntity, DateTime, QQueryOperations>
  playedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'playedAt');
    });
  }
}

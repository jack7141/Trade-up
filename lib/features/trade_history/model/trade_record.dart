class TradeRecord {
  final String id;
  final String symbol;
  final int pnl;
  final int trades;
  final double winRate;
  final bool isLong;
  final DateTime dateTime;
  final double? entryPrice;
  final double? exitPrice;
  final double quantity;
  final String? notes;

  TradeRecord({
    required this.id,
    required this.symbol,
    required this.pnl,
    required this.trades,
    required this.winRate,
    required this.isLong,
    required this.dateTime,
    this.entryPrice,
    this.exitPrice,
    required this.quantity,
    this.notes,
  });

  bool get isProfit => pnl > 0;

  double get profitPercentage {
    if (entryPrice == null || exitPrice == null) return 0.0;
    return ((exitPrice! - entryPrice!) / entryPrice!) * 100;
  }

  String get directionText => isLong ? 'Long' : 'Short';

  // JSON 직렬화 (나중에 API 연동시 사용)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'pnl': pnl,
      'trades': trades,
      'winRate': winRate,
      'isLong': isLong,
      'dateTime': dateTime.toIso8601String(),
      'entryPrice': entryPrice,
      'exitPrice': exitPrice,
      'quantity': quantity,
      'notes': notes,
    };
  }

  factory TradeRecord.fromJson(Map<String, dynamic> json) {
    return TradeRecord(
      id: json['id'],
      symbol: json['symbol'],
      pnl: json['pnl'],
      trades: json['trades'],
      winRate: json['winRate'].toDouble(),
      isLong: json['isLong'],
      dateTime: DateTime.parse(json['dateTime']),
      entryPrice: json['entryPrice']?.toDouble(),
      exitPrice: json['exitPrice']?.toDouble(),
      quantity: json['quantity'].toDouble(),
      notes: json['notes'],
    );
  }

  TradeRecord copyWith({
    String? id,
    String? symbol,
    int? pnl,
    int? trades,
    double? winRate,
    bool? isLong,
    DateTime? dateTime,
    double? entryPrice,
    double? exitPrice,
    double? quantity,
    String? notes,
  }) {
    return TradeRecord(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      pnl: pnl ?? this.pnl,
      trades: trades ?? this.trades,
      winRate: winRate ?? this.winRate,
      isLong: isLong ?? this.isLong,
      dateTime: dateTime ?? this.dateTime,
      entryPrice: entryPrice ?? this.entryPrice,
      exitPrice: exitPrice ?? this.exitPrice,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'TradeRecord(id: $id, symbol: $symbol, pnl: $pnl, trades: $trades, winRate: $winRate, isLong: $isLong, dateTime: $dateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TradeRecord && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

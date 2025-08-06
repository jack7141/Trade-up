import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trade_up/core/theme/app_theme.dart';

// --- 데이터 모델 (임시) ---
class Execution {
  final double price;
  final double quantity;
  Execution({required this.price, required this.quantity});
}

enum PositionSide { long, short }

// --- 새 매매 기록 화면 ---
class NewTradeScreen extends StatefulWidget {
  static const String routeName = 'add-trade';
  static const String routePath = '/add-trade';
  const NewTradeScreen({super.key});

  @override
  State<NewTradeScreen> createState() => _NewTradeScreenState();
}

class _NewTradeScreenState extends State<NewTradeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _slideController;

  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _orderValueController = TextEditingController();

  final String _selectedAsset = 'BTC/USDT';
  PositionSide _positionSide = PositionSide.long;

  final List<Execution> _entries = [];
  final List<Execution> _exits = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _priceController.addListener(_updateOrderValue);
    _quantityController.addListener(_updateOrderValue);

    // 애니메이션 시작
    _animationController.forward();
    _slideController.forward();
  }

  void _updateOrderValue() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    _orderValueController.text = (price * quantity).toStringAsFixed(2);
    setState(() {});
  }

  void _addExecution({required bool isEntry}) {
    final price = double.tryParse(_priceController.text);
    final quantity = double.tryParse(_quantityController.text);
    if (price != null && quantity != null) {
      setState(() {
        final newExecution = Execution(price: price, quantity: quantity);
        if (isEntry) {
          _entries.add(newExecution);
        } else {
          _exits.add(newExecution);
        }
        _priceController.clear();
        _quantityController.clear();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _orderValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLong = _positionSide == PositionSide.long;
    final screenWidth = MediaQuery.of(context).size.width;

    // 반응형 패딩과 간격 계산
    final horizontalPadding = math.max(
      16.0,
      math.min(24.0, screenWidth * 0.04),
    );
    final cardPadding = math.max(16.0, math.min(20.0, screenWidth * 0.035));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: AppTheme.primaryText,
            size: math.max(20.0, math.min(28.0, screenWidth * 0.06)),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Log Trade',
          style: GoogleFonts.montserrat(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: math.max(18.0, math.min(22.0, screenWidth * 0.05)),
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: horizontalPadding),
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentColor,
                foregroundColor: AppTheme.primaryText,
                elevation: 2,
                padding: EdgeInsets.symmetric(
                  horizontal: math.max(
                    16.0,
                    math.min(20.0, screenWidth * 0.04),
                  ),
                  vertical: math.max(8.0, math.min(12.0, screenWidth * 0.025)),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Save',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: math.max(14.0, math.min(16.0, screenWidth * 0.035)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _slideController,
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, -0.5),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _slideController,
                          curve: Curves.easeOutBack,
                        ),
                      ),
                  child: _buildAssetSelector(screenWidth),
                ),
                SizedBox(
                  height: math.max(16.0, math.min(20.0, screenWidth * 0.04)),
                ),
                Expanded(
                  child: screenWidth > 800
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 데스크톱: 좌우 분할
                            Expanded(
                              flex: 5,
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(-0.5, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _slideController,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                child: _buildOrderPanel(
                                  screenWidth,
                                  cardPadding,
                                  isLong,
                                ),
                              ),
                            ),
                            SizedBox(width: horizontalPadding),
                            Expanded(
                              flex: 4,
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(0.5, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _slideController,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                child: _buildPositionStatus(
                                  screenWidth,
                                  cardPadding,
                                ),
                              ),
                            ),
                          ],
                        )
                      : SingleChildScrollView(
                          // 모바일: 세로 스크롤
                          child: Column(
                            children: [
                              _buildOrderPanel(
                                screenWidth,
                                cardPadding,
                                isLong,
                              ),
                              SizedBox(height: horizontalPadding),
                              _buildPositionStatus(screenWidth, cardPadding),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssetSelector(double screenWidth) {
    final iconSize = math.max(20.0, math.min(28.0, screenWidth * 0.06));
    final fontSize = math.max(16.0, math.min(20.0, screenWidth * 0.045));
    final padding = math.max(12.0, math.min(18.0, screenWidth * 0.04));

    return GestureDetector(
      onTap: () {
        // TODO: Show Asset Search Screen
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: padding * 0.8,
        ),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.currency_bitcoin,
                color: AppTheme.accentColor,
                size: iconSize,
              ),
            ),
            SizedBox(width: padding * 0.8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedAsset,
                    style: GoogleFonts.montserrat(
                      color: AppTheme.primaryText,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Bitcoin / Tether',
                    style: GoogleFonts.montserrat(
                      color: AppTheme.secondaryText,
                      fontSize: fontSize * 0.7,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.search,
              color: AppTheme.secondaryText,
              size: iconSize * 0.9,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderPanel(double screenWidth, double cardPadding, bool isLong) {
    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.backgroundColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Entry',
            style: GoogleFonts.montserrat(
              color: AppTheme.primaryText,
              fontSize: math.max(16.0, math.min(20.0, screenWidth * 0.045)),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: cardPadding * 0.8),
          _buildPositionSideSelector(screenWidth),
          SizedBox(height: cardPadding),
          _buildTextField(
            controller: _priceController,
            label: 'Price (USDT)',
            screenWidth: screenWidth,
            icon: Icons.price_change,
          ),
          SizedBox(height: cardPadding * 0.8),
          _buildTextField(
            controller: _quantityController,
            label: 'Quantity (${_selectedAsset.split('/')[0]})',
            screenWidth: screenWidth,
            icon: Icons.balance,
          ),
          SizedBox(height: cardPadding * 0.8),
          _buildTextField(
            controller: _orderValueController,
            label: 'Order Value (USDT)',
            screenWidth: screenWidth,
            readOnly: true,
            icon: Icons.calculate,
          ),
          SizedBox(height: cardPadding),
          Row(
            children: [
              Expanded(
                child: _buildExecuteButton(
                  isEntry: true,
                  isLong: isLong,
                  screenWidth: screenWidth,
                ),
              ),
              SizedBox(width: cardPadding * 0.5),
              Expanded(
                child: _buildExecuteButton(
                  isEntry: false,
                  isLong: isLong,
                  screenWidth: screenWidth,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPositionSideSelector(double screenWidth) {
    final height = math.max(40.0, math.min(50.0, screenWidth * 0.08));

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor, width: 1),
      ),
      child: Row(
        children: [
          _buildSideButton('Long', PositionSide.long, screenWidth),
          _buildSideButton('Short', PositionSide.short, screenWidth),
        ],
      ),
    );
  }

  Widget _buildSideButton(String text, PositionSide side, double screenWidth) {
    final isSelected = _positionSide == side;
    final color = side == PositionSide.long
        ? AppTheme.positiveColor
        : AppTheme.negativeColor;
    final fontSize = math.max(12.0, math.min(16.0, screenWidth * 0.035));

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(2),
        child: GestureDetector(
          onTap: () {
            setState(() => _positionSide = side);
            // 햅틱 피드백 추가
            // HapticFeedback.selectionClick();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: isSelected
                  ? LinearGradient(
                      colors: [color, color.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.transparent,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    side == PositionSide.long
                        ? Icons.trending_up
                        : Icons.trending_down,
                    color: isSelected
                        ? AppTheme.primaryText
                        : AppTheme.secondaryText,
                    size: fontSize,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    text,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppTheme.primaryText
                          : AppTheme.secondaryText,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required double screenWidth,
    bool readOnly = false,
    IconData? icon,
  }) {
    final fontSize = math.max(14.0, math.min(18.0, screenWidth * 0.04));
    final labelFontSize = math.max(12.0, math.min(16.0, screenWidth * 0.032));
    final padding = math.max(12.0, math.min(16.0, screenWidth * 0.035));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: GoogleFonts.robotoMono(
          color: readOnly ? AppTheme.secondaryText : AppTheme.primaryText,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.montserrat(
            color: AppTheme.secondaryText,
            fontSize: labelFontSize,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: icon != null
              ? Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Icon(
                    icon,
                    color: AppTheme.accentColor.withOpacity(0.7),
                    size: fontSize * 1.2,
                  ),
                )
              : null,
          suffixIcon: readOnly
              ? Icon(
                  Icons.lock_outline,
                  color: AppTheme.secondaryText.withOpacity(0.5),
                  size: fontSize,
                )
              : null,
          filled: true,
          fillColor: readOnly
              ? AppTheme.backgroundColor.withOpacity(0.5)
              : AppTheme.backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.borderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppTheme.accentColor, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: padding * 0.9,
          ),
        ),
      ),
    );
  }

  Widget _buildExecuteButton({
    required bool isEntry,
    required bool isLong,
    required double screenWidth,
  }) {
    final String text;
    final Color color;
    final IconData icon;

    if (isEntry) {
      text = isLong ? 'Buy / Long' : 'Sell / Short';
      color = isLong ? AppTheme.positiveColor : AppTheme.negativeColor;
      icon = isLong ? Icons.trending_up : Icons.trending_down;
    } else {
      text = isLong ? 'Sell / Exit' : 'Buy / Exit';
      color = isLong ? AppTheme.negativeColor : AppTheme.positiveColor;
      icon = Icons.exit_to_app;
    }

    final fontSize = math.max(12.0, math.min(16.0, screenWidth * 0.032));
    final padding = math.max(12.0, math.min(16.0, screenWidth * 0.035));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          _addExecution(isEntry: isEntry);
          // 햅틱 피드백
          // HapticFeedback.lightImpact();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppTheme.primaryText,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: padding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: fontSize * 1.1, color: AppTheme.primaryText),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionStatus(double screenWidth, double cardPadding) {
    final entryValue = _entries.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final entryQty = _entries.fold<double>(
      0,
      (sum, item) => sum + item.quantity,
    );
    final avgEntryPrice = entryQty > 0 ? entryValue / entryQty : 0;

    final exitValue = _exits.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
    final exitQty = _exits.fold<double>(0, (sum, item) => sum + item.quantity);
    final avgExitPrice = exitQty > 0 ? exitValue / exitQty : 0;

    // P&L 계산
    final remainingQty = entryQty - exitQty;
    final realizedPnL = exitQty > 0 && entryQty > 0
        ? (avgExitPrice - avgEntryPrice) * exitQty
        : 0;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.backgroundColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assessment,
                color: AppTheme.accentColor,
                size: math.max(18.0, math.min(24.0, screenWidth * 0.05)),
              ),
              SizedBox(width: cardPadding * 0.5),
              Text(
                'Position Status',
                style: GoogleFonts.montserrat(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: math.max(16.0, math.min(20.0, screenWidth * 0.045)),
                ),
              ),
            ],
          ),
          Divider(color: AppTheme.borderColor, height: cardPadding * 1.5),

          // Entry Section
          _buildSectionHeader(
            'Entry',
            Icons.login,
            AppTheme.positiveColor,
            screenWidth,
          ),
          SizedBox(height: cardPadding * 0.5),
          _buildStatusRow(
            'Avg. Entry Price',
            '\$${avgEntryPrice.toStringAsFixed(2)}',
            screenWidth,
          ),
          _buildStatusRow(
            'Total Entry Qty',
            '${entryQty.toStringAsFixed(4)} BTC',
            screenWidth,
          ),
          _buildStatusRow(
            'Entry Value',
            '\$${entryValue.toStringAsFixed(2)}',
            screenWidth,
          ),

          SizedBox(height: cardPadding),

          // Exit Section
          _buildSectionHeader(
            'Exit',
            Icons.logout,
            AppTheme.negativeColor,
            screenWidth,
          ),
          SizedBox(height: cardPadding * 0.5),
          _buildStatusRow(
            'Avg. Exit Price',
            '\$${avgExitPrice.toStringAsFixed(2)}',
            screenWidth,
          ),
          _buildStatusRow(
            'Total Exit Qty',
            '${exitQty.toStringAsFixed(4)} BTC',
            screenWidth,
          ),
          _buildStatusRow(
            'Exit Value',
            '\$${exitValue.toStringAsFixed(2)}',
            screenWidth,
          ),

          SizedBox(height: cardPadding),

          // Summary Section
          Container(
            padding: EdgeInsets.all(cardPadding * 0.8),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: realizedPnL >= 0
                    ? AppTheme.positiveColor.withOpacity(0.3)
                    : AppTheme.negativeColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildStatusRow(
                  'Remaining Qty',
                  '${remainingQty.toStringAsFixed(4)} BTC',
                  screenWidth,
                  isHighlight: true,
                ),
                _buildStatusRow(
                  'Realized P&L',
                  '${realizedPnL >= 0 ? '+' : ''}\$${realizedPnL.toStringAsFixed(2)}',
                  screenWidth,
                  isHighlight: true,
                  color: realizedPnL >= 0
                      ? AppTheme.positiveColor
                      : AppTheme.negativeColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    IconData icon,
    Color color,
    double screenWidth,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            color: color,
            size: math.max(14.0, math.min(18.0, screenWidth * 0.04)),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.montserrat(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: math.max(13.0, math.min(16.0, screenWidth * 0.035)),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(
    String label,
    String value,
    double screenWidth, {
    bool isHighlight = false,
    Color? color,
  }) {
    final labelFontSize = math.max(11.0, math.min(14.0, screenWidth * 0.03));
    final valueFontSize = math.max(12.0, math.min(15.0, screenWidth * 0.032));

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: math.max(3.0, math.min(6.0, screenWidth * 0.01)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 3,
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                color: isHighlight
                    ? AppTheme.primaryText.withOpacity(0.9)
                    : AppTheme.secondaryText,
                fontSize: labelFontSize,
                fontWeight: isHighlight ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Text(
              value,
              style: GoogleFonts.robotoMono(
                color:
                    color ??
                    (isHighlight
                        ? AppTheme.primaryText
                        : AppTheme.primaryText.withOpacity(0.9)),
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
                fontSize: valueFontSize,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

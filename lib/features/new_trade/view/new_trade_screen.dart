import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- 데이터 모델 (임시) ---
// 실제 앱에서는 별도의 model 파일로 분리됩니다.
class Execution {
  final double price;
  final double quantity;

  Execution({required this.price, required this.quantity});
}

// --- 새 매매 기록 화면 ---
class NewTradeScreen extends StatefulWidget {
  static const String routeName = 'add-trade';
  static const String routePath = '/add-trade';
  const NewTradeScreen({super.key});

  @override
  State<NewTradeScreen> createState() => _NewTradeScreenState();
}

class _NewTradeScreenState extends State<NewTradeScreen> {
  // --- 디자인 시스템 (임시) ---
  static const Color _backgroundColor = Color(0xFF0D0D0D);
  static const Color _surfaceColor = Color(0xFF1A1A1A);
  static const Color _borderColor = Color(0xFF2B3139);
  static const Color _primaryTextColor = Color(0xFFFFFFFF);
  static const Color _secondaryTextColor = Color(0xFF848E9C);
  static const Color _accentColor = Color(0xFFF7931A);
  static const Color _positiveColor = Color(0xFF0ECB81);
  static const Color _negativeColor = Color(0xFFF23645);

  String _selectedAsset = 'Select Asset';
  final List<Execution> _buyEntries = [];
  final List<Execution> _sellEntries = [];

  // 자산 선택 팝업을 표시하는 함수
  void _showAssetSelectionModal() {
    // 임시 데이터
    final List<String> tickers = [
      'BTC/USDT',
      'ETH/USDT',
      'SOL/USDT',
      'BNB/USDT',
      'XRP/USDT',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: _surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _borderColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: _buildInputDecoration(hintText: 'Search asset...'),
                style: GoogleFonts.montserrat(color: _primaryTextColor),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: tickers.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        tickers[index],
                        style: GoogleFonts.montserrat(color: _primaryTextColor),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedAsset = tickers[index];
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const Divider(color: _borderColor),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 매수/매도 내역 추가 다이얼로그를 표시하는 함수
  void _showAddExecutionDialog({required bool isBuy}) {
    final priceController = TextEditingController();
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _surfaceColor,
          title: Text(
            isBuy ? 'Add Buy Entry' : 'Add Sell Exit',
            style: GoogleFonts.montserrat(color: _primaryTextColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: priceController,
                decoration: _buildInputDecoration(hintText: 'Price'),
                keyboardType: TextInputType.number,
                style: GoogleFonts.montserrat(color: _primaryTextColor),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: _buildInputDecoration(hintText: 'Quantity'),
                keyboardType: TextInputType.number,
                style: GoogleFonts.montserrat(color: _primaryTextColor),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(color: _secondaryTextColor),
              ),
            ),
            TextButton(
              onPressed: () {
                final price = double.tryParse(priceController.text);
                final quantity = double.tryParse(quantityController.text);
                if (price != null && quantity != null) {
                  setState(() {
                    final newEntry = Execution(
                      price: price,
                      quantity: quantity,
                    );
                    if (isBuy) {
                      _buyEntries.add(newEntry);
                    } else {
                      _sellEntries.add(newEntry);
                    }
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'Add',
                style: GoogleFonts.montserrat(color: _accentColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'New Trade',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Save',
              style: GoogleFonts.montserrat(
                color: _accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- 자산 선택 ---
          _buildSectionHeader(title: 'Asset'),
          GestureDetector(
            onTap: _showAssetSelectionModal,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: _borderColor)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedAsset,
                    style: GoogleFonts.montserrat(
                      color: _selectedAsset == 'Select Asset'
                          ? _secondaryTextColor
                          : _primaryTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.expand_more, color: _secondaryTextColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // --- 거래 내역 ---
          _buildSectionHeader(title: 'Executions'),
          _buildExecutionsCard(
            title: 'Buy Entries',
            entries: _buyEntries,
            onAdd: () => _showAddExecutionDialog(isBuy: true),
            isBuy: true,
          ),
          const SizedBox(height: 16),
          _buildExecutionsCard(
            title: 'Sell Exits',
            entries: _sellEntries,
            onAdd: () => _showAddExecutionDialog(isBuy: false),
            isBuy: false,
          ),
          const SizedBox(height: 32),

          // --- 분석 ---
          _buildSectionHeader(title: 'Analysis'),
          TextField(
            decoration: _buildInputDecoration(
              hintText: 'Tags (e.g. #Breakout, #FOMO)',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: _buildInputDecoration(
              hintText: 'Log your rationale, emotions, etc.',
            ),
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          color: _primaryTextColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildExecutionsCard({
    required String title,
    required List<Execution> entries,
    required VoidCallback onAdd,
    required bool isBuy,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              color: _primaryTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          if (entries.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'No entries yet.',
                style: TextStyle(color: _secondaryTextColor),
              ),
            )
          else
            ...entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price: ${entry.price}',
                      style: GoogleFonts.montserrat(color: _secondaryTextColor),
                    ),
                    Text(
                      'Qty: ${entry.quantity}',
                      style: GoogleFonts.montserrat(color: _secondaryTextColor),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: onAdd,
              icon: Icon(
                Icons.add,
                size: 16,
                color: isBuy ? _positiveColor : _negativeColor,
              ),
              label: Text(
                'Add Entry',
                style: GoogleFonts.montserrat(
                  color: isBuy ? _positiveColor : _negativeColor,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: (isBuy ? _positiveColor : _negativeColor)
                    .withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.montserrat(
        color: _secondaryTextColor.withOpacity(0.5),
      ),
      filled: true,
      fillColor: _surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _accentColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

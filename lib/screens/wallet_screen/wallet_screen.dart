// lib/screens/wallet_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:jara_market/screens/add_money_screen/add_money_screen.dart';
import 'package:jara_market/screens/wallet_screen/controller/wallet_controller.dart';
import '../../widgets/custom_back_header.dart';
import '../../widgets/balance_card.dart';
import '../../services/api_service.dart';

WalletController controller = Get.put(WalletController());

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  bool _isBalanceVisible = true;
  bool _isLoading = true;
  String _balance = '0.00';
  List<dynamic> _transactions = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWalletData();
  }

  Future<void> _fetchWalletData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      // In a real app, you would get the user ID from a session or auth provider
      final userId = 'current-user-id';
      
      // Fetch wallet balance - this would be a separate API call in a real app
      // For now, we'll simulate it
      await Future.delayed(const Duration(milliseconds: 800));
      
      setState(() {
        _balance = '10,000,000.34'; // This would come from the API
        _isLoading = false;
      });
      
      // Fetch transaction history
      // In a real app, you would have a getWalletTransactions API method
      // For now, we'll leave it empty
      _transactions = [];
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching wallet data: $e';
      });
      print(_errorMessage);
    }
  }

  Future<void> _fundWallet(double amount) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      final fundData = {
        'amount': amount,
        'payment_method': 'card', // This could be passed as a parameter
        'user_id': 'current-user-id', // In a real app, get this from auth provider
      };
      
      final response = await _apiService.fundWallet(fundData);
      
      setState(() {
        _isLoading = false;
      });
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wallet funded successfully!')),
        );
        
        // Refresh wallet data
        _fetchWalletData();
        
        // Return success to the calling screen if needed
        return responseData;
      } else {
        setState(() {
          _errorMessage = 'Failed to fund wallet: ${response.statusCode}';
        });
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_errorMessage!)),
        );
        
        throw Exception(_errorMessage);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage!)),
      );
      
      throw Exception(_errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const CustomBackHeader(title: 'Wallet'),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BalanceCard(
                            balance: _balance,
                            subtitle: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                            isBalanceVisible: _isBalanceVisible,
                            onToggleVisibility: () {
                              setState(() {
                                _isBalanceVisible = !_isBalanceVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                icon: Icons.add,
                                label: 'Add Money',
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddMoneyScreen(),
                                    ),
                                  );
                                  
                                  // If result contains amount, fund the wallet
                                  if (result != null && result is Map && result.containsKey('amount')) {
                                    try {
                                      await _fundWallet(result['amount']);
                                    } catch (e) {
                                      // Error already handled in _fundWallet
                                    }
                                  }
                                },
                              ),
                              _buildActionButton(
                                icon: Icons.arrow_downward,
                                label: 'Withdraw',
                                onTap: () {
                                  // TODO: Implement withdraw action
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Withdraw feature coming soon')),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Wallet History',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _transactions.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _transactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction = _transactions[index];
                                    return ListTile(
                                      leading: Icon(
                                        transaction['type'] == 'credit' ? Icons.arrow_upward : Icons.arrow_downward,
                                        color: transaction['type'] == 'credit' ? Colors.green : Colors.red,
                                      ),
                                      title: Text(transaction['description']),
                                      subtitle: Text(transaction['date']),
                                      trailing: Text(
                                        '${transaction['type'] == 'credit' ? '+' : '-'}${transaction['amount']}',
                                        style: TextStyle(
                                          color: transaction['type'] == 'credit' ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.block,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 256), // Increase the height here
        ],
      ),
    );
  }
}
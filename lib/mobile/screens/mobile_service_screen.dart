import 'package:bockchain/mobile/screens/mobile_0fee_screen.dart';
import 'package:bockchain/mobile/screens/mobile_accountstate_screen.dart';
import 'package:bockchain/mobile/screens/mobile_alpha_sceen.dart';
import 'package:bockchain/mobile/screens/mobile_alphaevents_screen.dart';
import 'package:bockchain/mobile/screens/mobile_buy_screen.dart';
import 'package:bockchain/mobile/screens/mobile_copytrading_screen.dart';
import 'package:bockchain/mobile/screens/mobile_customerservice_screen.dart';
import 'package:bockchain/mobile/screens/mobile_depwith_screen.dart';
import 'package:bockchain/mobile/screens/mobile_disable_screen.dart';
import 'package:bockchain/mobile/screens/mobile_discountbuy_screen.dart';
import 'package:bockchain/mobile/screens/mobile_dualinvest_screen.dart';
import 'package:bockchain/mobile/screens/mobile_earn_screen.dart';
import 'package:bockchain/mobile/screens/mobile_ethstaking_screen.dart';
import 'package:bockchain/mobile/screens/mobile_futuremasters_screen.dart';
import 'package:bockchain/mobile/screens/mobile_futures_screen.dart';
import 'package:bockchain/mobile/screens/mobile_launchpool_screen.dart';
import 'package:bockchain/mobile/screens/mobile_learnearn_screen.dart';
import 'package:bockchain/mobile/screens/mobile_loan_screen.dart';
import 'package:bockchain/mobile/screens/mobile_options_screem.dart';
import 'package:bockchain/mobile/screens/mobile_otc_screen.dart';
import 'package:bockchain/mobile/screens/mobile_p2p_screen.dart';
import 'package:bockchain/mobile/screens/mobile_referral_screen.dart';
import 'package:bockchain/mobile/screens/mobile_rewards_screen.dart';
import 'package:bockchain/mobile/screens/mobile_rwusd_screen.dart';
import 'package:bockchain/mobile/screens/mobile_sharia_screen.dart';
import 'package:bockchain/mobile/screens/mobile_simpleearn_screen.dart';
import 'package:bockchain/mobile/screens/mobile_softstaking_screen.dart';
import 'package:bockchain/mobile/screens/mobile_solstaking_screen.dart';
import 'package:bockchain/mobile/screens/mobile_spot_screen.dart';
import 'package:bockchain/mobile/screens/mobile_spotcolo_screen.dart';
import 'package:bockchain/mobile/screens/mobile_square_screen.dart';
import 'package:bockchain/mobile/screens/mobile_transfer_screen.dart';
import 'package:bockchain/mobile/screens/mobile_wallet_screen.dart';
import 'package:bockchain/mobile/screens/mobile_yeildarena_screen.dart';
import 'package:bockchain/mobile/screens/smart_arbitrage_screen.dart';
import 'package:flutter/material.dart';

class MobileServiceScreen extends StatelessWidget {
  const MobileServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Services',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search more services',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
            
            // Shortcut Section (only visible on first tab)
            _buildShortcutSection(),
            
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                isScrollable: true,
                indicatorColor: const Color.fromARGB(255, 122, 79, 223),
                indicatorWeight: 3,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Common Function'),
                  Tab(text: 'Gift & Campaign'),
                  Tab(text: 'Trade'),
                  Tab(text: 'Earn'),
                  Tab(text: 'Finance'),
                  Tab(text: 'Information'),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                children: [
                  _buildCommonFunctionTab(),
                  _buildGiftCampaignTab(),
                  _buildTradeTab(),
                  _buildEarnTab(),
                  _buildFinanceTab(),
                  _buildInformationTab(),
                  _buildHelpSupportTab()

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shortcut',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add to Homepage'),
              Switch(
                value: true,
                onChanged: (value) {},
                activeColor: const Color.fromARGB(255, 122, 79, 223),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShortcutIcon(Icons.qr_code_scanner, 'Scanner'),
              _buildShortcutIcon(Icons.settings, 'Settings'),
              _buildShortcutIcon(Icons.person_outline, 'Profile'),
              _buildShortcutIcon(Icons.notifications_outlined, 'Notifications'),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Recommend',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRecommendItem(Icons.add_circle_outline, 'New Listing\nPromos'),
              _buildRecommendItem(Icons.monetization_on_outlined, 'Simple Earn'),
              _buildRecommendItem(Icons.person_outline, 'Referral'),
              _buildRecommendItem(Icons.event, 'Alpha Events'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRecommendItem(Icons.people_outline, 'P2P'),
              _buildRecommendItem(Icons.square_outlined, 'Square'),
              const SizedBox(width: 80),
              const SizedBox(width: 80),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 122, 79, 223).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color.fromARGB(255, 122, 79, 223), size: 24),
        ),
      ],
    );
  }

  Widget _buildRecommendItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildCommonFunctionTab() {
    return Container(
      color: Colors.white,
      child:Builder(
        builder:(BuildContext context){   
      return GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(16),
        children: [ //demo trading, recurring buy, 
          _buildServiceItem(Icons.double_arrow_outlined, 'Transfer', () => _navigateToScreen(context,'MobileTransferScreen')),
          _buildServiceItem(Icons.wallet, 'Binance Wallet', () => _navigateToScreen(context,'MobileWalletScreen')),
          _buildServiceItem(Icons.wallet_membership_outlined, 'Buy Crypto', () => _navigateToScreen(context,'MobileBuyScreen')),
          _buildServiceItem(Icons.disabled_by_default_outlined, 'Disable Account', () => _navigateToScreen(context,'MobileDisableScreen')),
          _buildServiceItem(Icons.account_balance_outlined, 'Account Statement', () => _navigateToScreen(context,'MobileAccountstateScreen')),
          _buildServiceItem(Icons.launch_outlined, 'Launchpool', () => _navigateToScreen(context,'MobileLaunchpoolScreen')),
          //_buildServiceItem(Icons.file_download_outlined, 'Deposit Fiat', () => _navigateToScreen('MobileDepositFiatScreen')),
          //_buildServiceItem(Icons.download_outlined, 'Deposit', () => _navigateToScreen('MobileDepositScreen')),
          _buildServiceItem(Icons.person_outline, 'Referral', () => _navigateToScreen(context,'MobileReferralScreen')),
          //_buildServiceItem(Icons.payment, 'Pay', () => _navigateToScreen('MobilePayScreen')),
          //_buildServiceItem(Icons.list_alt, 'Orders', () => _navigateToScreen('MobileOrdersScreen')),
          //_buildServiceItem(Icons.sell_outlined, 'Sell to Fiat', () => _navigateToScreen('MobileSellToFiatScreen')),
          //_buildServiceItem(Icons.file_upload_outlined, 'Withdraw Fiat', () => _navigateToScreen('MobileWithdrawFiatScreen')),
          //_buildServiceItem(Icons.security, 'Security', () => _navigateToScreen('MobileSecurityScreen')),
        ],
      );
        },
      ),
    );
  }

  Widget _buildGiftCampaignTab() {
    return Container(
      color: Colors.white,
      child: Builder(
        builder: (BuildContext context){
          return GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(16),
        children: [
          //_buildServiceItem(Icons.today, 'Word of the\nDay', () => _navigateToScreen('MobileWordOfTheDayScreen')),
          _buildServiceItem(Icons.add_circle_outline, 'New Listing\nPromos', () => _navigateToScreen(context,'MobileNewListingPromosScreen')),
          _buildServiceItem(Icons.stadium, 'Spot\nColosseum', () => _navigateToScreen(context,'MobileSpotColosseumScreen')),
          //_buildServiceItem(Icons.games, 'Button Game', () => _navigateToScreen('MobileButtonGameScreen')),
          _buildServiceItem(Icons.credit_card_off, '0 Fees via Card', () => _navigateToScreen(context,'Mobile0FeesViaCardScreen')),
          //_buildServiceItem(Icons.celebration, 'Carnival Quest', () => _navigateToScreen('MobileCarnivalQuestScreen')),
          _buildServiceItem(Icons.card_giftcard, 'Refer & Win\nBNB', () => _navigateToScreen(context,'MobileReferWinBNBScreen')),
          //_buildServiceItem(Icons.search, 'BNB ATH', () => _navigateToScreen('MobileBNBATHScreen')),
          //_buildServiceItem(Icons.calendar_month, 'Monthly\nChallenge', () => _navigateToScreen('MobileMonthlyChallengeScreen')),
          _buildServiceItem(Icons.stars, 'Rewards Hub', () => _navigateToScreen(context,'MobileRewardsHubScreen')),
          _buildServiceItem(Icons.trending_up, 'Futures\nMasters', () => _navigateToScreen(context,'MobileFuturesMastersScreen')),
          //_buildServiceItem(Icons.card_giftcard, 'My Gifts', () => _navigateToScreen('MobileMyGiftsScreen')),
          _buildServiceItem(Icons.school, 'Learn & Earn', () => _navigateToScreen(context,'MobileLearnEarnScreen')),
          //_buildServiceItem(Icons.camera_alt, 'Red Packet', () => _navigateToScreen('MobileRedPacketScreen')),
          _buildServiceItem(Icons.event, 'Alpha Events', () => _navigateToScreen(context,'MobileAlphaEventsScreen')),
        ],
          );
        },
      ),
    );
  }

  Widget _buildTradeTab() {
    return Container(
      color: Colors.white,
      child: Builder(
        builder: (BuildContext context){
          return GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(16),
        children: [
          //_buildServiceItem(Icons.currency_exchange, 'Convert', () => _navigateToScreen('MobileConvertScreen')),
          _buildServiceItem(Icons.circle_outlined, 'Spot', () => _navigateToScreen(context,'MobileSpotScreen')),
          _buildServiceItem(Icons.add_circle_outlined, 'Alpha', () => _navigateToScreen(context,'MobileAlphaScreen')),
          //_buildServiceItem(Icons.show_chart, 'Margin', () => _navigateToScreen('MobileMarginScreen')),
          _buildServiceItem(Icons.list, 'Futures', () => _navigateToScreen(context,'MobileFuturesScreen')),
          _buildServiceItem(Icons.copy, 'Copy Trading', () => _navigateToScreen(context,'MobileCopyTradingScreen')),
          _buildServiceItem(Icons.camera, 'OTC', () => _navigateToScreen(context,'MobileOTCScreen')),
          _buildServiceItem(Icons.people, 'P2P', () => _navigateToScreen(context,'MobileP2PScreen')),
          //_buildServiceItem(Icons.smart_toy, 'Trading Bots', () => _navigateToScreen(context,'MobileTradingBotsScreen')),
          //_buildServiceItem(Icons.refresh, 'Convert\nRecurring', () => _navigateToScreen('MobileConvertRecurringScreen')),
          //_buildServiceItem(Icons.timeline, 'Index-Linked', () => _navigateToScreen('MobileIndexLinkedScreen')),
          _buildServiceItem(Icons.bar_chart, 'Options', () => _navigateToScreen(context,'MobileOptionsScreen')),
        ],
          );
        },
      ),
    );
  }

  Widget _buildEarnTab() {
    return Container(
      color: Colors.white,
      child: Builder(
        builder: (BuildContext context){
          return GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(16),
        children: [
          _buildServiceItem(Icons.monetization_on, 'Earn', () => _navigateToScreen(context,'MobileEarnScreen')),
          _buildServiceItem(Icons.layers, 'SOL Staking', () => _navigateToScreen(context,'MobileSOLStakingScreen')),
          _buildServiceItem(Icons.smart_toy, 'Smart\nArbitrage', () => _navigateToScreen(context,'MobileSmartArbitrageScreen')),
          _buildServiceItem(Icons.account_balance, 'Yield Arena', () => _navigateToScreen(context,'MobileYieldArenaScreen')),
          //_buildServiceItem(Icons.local_fire_department, 'Super Mine', () => _navigateToScreen('MobileSuperMineScreen')),
          _buildServiceItem(Icons.discount, 'Discount Buy', () => _navigateToScreen(context,'MobileDiscountBuyScreen')),
          _buildServiceItem(Icons.circle, 'RWUSD', () => _navigateToScreen(context,'MobileRWUSDScreen')),
          _buildServiceItem(Icons.circle, 'BFUSD', () => _navigateToScreen(context,'MobileBFUSDScreen')),
          //_buildServiceItem(Icons.dashboard, 'On-chain\nYields', () => _navigateToScreen('MobileOnChainYieldsScreen')),
          _buildServiceItem(Icons.trending_up, 'Soft Staking', () => _navigateToScreen(context,'MobileSoftStakingScreen')),
          _buildServiceItem(Icons.monetization_on, 'Simple Earn', () => _navigateToScreen(context,'MobileSimpleEarnScreen')),
          //_buildServiceItem(Icons.water_drop, 'Pool', () => _navigateToScreen('MobilePoolScreen')),
          _buildServiceItem(Icons.account_balance_wallet, 'ETH Staking', () => _navigateToScreen(context,'MobileETHStakingScreen')),
          _buildServiceItem(Icons.insights, 'Dual\nInvestment', () => _navigateToScreen(context,'MobileDualInvestmentScreen')),
        ],
          );
        },
      ),
    );
  }

  Widget _buildFinanceTab() {
    return Container(
      color: Colors.white,
      child: Builder(
        builder:(BuildContext context){
          return GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(16),
        children: [
          _buildServiceItem(Icons.handshake, 'Loans', () => _navigateToScreen(context,'MobileLoansScreen')),
          _buildServiceItem(Icons.savings, 'Sharia Earn', () => _navigateToScreen(context,'MobileShariaEarnScreen')),
          //_buildServiceItem(Icons.monetization_on, 'VIP Loan', () => _navigateToScreen('MobileVIPLoanScreen')),
          //_buildServiceItem(Icons.lock, 'Fixed Rate\nLoans', () => _navigateToScreen('MobileFixedRateLoansScreen')),
          //_buildServiceItem(Icons.trending_up, 'Binance Wealth', () => _navigateToScreen('MobileBinanceWealthScreen')),
        ],
          );
        },
      ),
    );
  }

  Widget _buildInformationTab() {
    return Container(
      color: Colors.white,
      child: Builder(
        builder:(BuildContext context){
          return GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(16),
        children: [
                //_buildServiceItem(Icons.chat, 'Chat', () => _navigateToScreen('MobileChatScreen')),
                _buildServiceItem(Icons.square_outlined, 'Square', () => _navigateToScreen(context,'MobileSquareScreen')),
                //_buildServiceItem(Icons.school, 'Binance\nAcademy', () => _navigateToScreen('MobileBinanceAcademyScreen')),
                //_buildServiceItem(Icons.live_tv, 'Live', () => _navigateToScreen('MobileLiveScreen')),
                //_buildServiceItem(Icons.research, 'Research', () => _navigateToScreen('MobileResearchScreen')),
                //_buildServiceItem(Icons.chat_bubble, 'Futures\nChatroom', () => _navigateToScreen('MobileFuturesChatroomScreen')),
                _buildServiceItem(Icons.description, 'Deposit &\nWithdrawal St...', () => _navigateToScreen(context,'MobileDepositWithdrawalScreen')),
                //_buildServiceItem(Icons.verified, 'Proof of\nReserves', () => _navigateToScreen('MobileProofOfReservesScreen')),
                      ],
          );
        },
      ),
    );
  }

  Widget _buildHelpSupportTab() {
    return Container(
      color: Colors.white,
      child: Builder(
        builder:(BuildContext context){
          return GridView.count(
        crossAxisCount: 4,
        padding: const EdgeInsets.all(16),
        children: [
                _buildServiceItem(Icons.headset_mic, 'Customer\nService', () => _navigateToScreen(context,'MobileCustomerServiceScreen')),
            ],
          );
        },
      ),
    );
  }
            /*const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Help & Support',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                //_buildServiceItem(Icons.warning, 'Action\nRequired', () => _navigateToScreen('MobileActionRequiredScreen')),
                //_buildServiceItem(Icons.verified, 'Binance Verify', () => _navigateToScreen('MobileBinanceVerifyScreen')),
                //_buildServiceItem(Icons.support, 'Support', () => _navigateToScreen('MobileSupportScreen')),
                _buildServiceItem(Icons.headset_mic, 'Customer\nService', () => _navigateToScreen('MobileCustomerServiceScreen')),
                //_buildServiceItem(Icons.self_improvement, 'Self Service', () => _navigateToScreen('MobileSelfServiceScreen')),
              ],
            ),*/
            /*const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Others',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),*/
            /*GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _buildServiceItem(Icons.account_circle, 'Third-party\nAccount', () => _navigateToScreen('MobileThirdPartyAccountScreen')),
                _buildServiceItem(Icons.extension, 'Affiliate', () => _navigateToScreen('MobileAffiliateScreen')),
                _buildServiceItem(Icons.face, 'Megadrop', () => _navigateToScreen('MobileMegadropScreen')),
                _buildServiceItem(Icons.lock_open, 'Token Unlock', () => _navigateToScreen('MobileTokenUnlockScreen')),
                //_buildServiceItem(Icons.card_giftcard, 'Gift Card', () => _navigateToScreen('MobileGiftCardScreen')),
                //_buildServiceItem(Icons.insights, 'Trading Insight', () => _navigateToScreen('MobileTradingInsightScreen')),
                //_buildServiceItem(Icons.api, 'API\nManagement', () => _navigateToScreen('MobileAPIManagementScreen')),
                _buildServiceItem(Icons.trending_up, 'Fan Token', () => _navigateToScreen('MobileFanTokenScreen')),
                _buildServiceItem(Icons.image, 'Binance NFT', () => _navigateToScreen('MobileBinanceNFTScreen')),
                _buildServiceItem(Icons.store, 'Marketplace', () => _navigateToScreen('MobileMarketplaceScreen')),
                _buildServiceItem(Icons.circle, 'BABT', () => _navigateToScreen('MobileBABTScreen')),
                _buildServiceItem(Icons.send, 'Send Cash', () => _navigateToScreen('MobileSendCashScreen')),
                _buildServiceItem(Icons.favorite, 'Charity', () => _navigateToScreen('MobileCharityScreen')),
              ],
            ),*/
        
  }

  Widget _buildServiceItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 24, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  

  void _navigateToScreen(BuildContext context, String screenName) {
  Widget screen;
  
  switch (screenName) {
    case 'MobileTransferScreen':
      screen = MobileTransferScreen();
      break;
    case 'MobileWalletScreen':
      screen = MobileWalletScreen();
      break;
    case 'MobileBuyScreen':
      screen = MobileBuyScreen();
      break;
    case 'MobileDisableScreen':
      screen = MobileDisableScreen();
      break;
    case 'MobileAccountstateScreen':
      screen = MobileAccountStateScreen();
      break;
    case 'MobileLaunchpoolScreen':
      screen = MobileLaunchpoolScreen();
      break;
    case 'MobileReferralScreen':
      screen = MobileReferralScreen();
      break;
    case 'MobileNewListingPromosScreen':
      screen = MobileNewListingScreen();
      break;
    case 'MobileSpotColosseumScreen':
      screen = MobileSpotColoScreen();
      break;
    case 'Mobile0FeesViaCardScreen':
      screen = Mobile0FeeScreen();
      break;
    case 'MobileReferWinBNBScreen':
      screen = MobileReferralScreen();
      break;
    case 'MobileRewardsHubScreen':
      screen = MobileRewardsScreen();
      break;
    case 'MobileFuturesMastersScreen':
      screen = MobileFutureMastersScreen();
      break;
    case 'MobileLearnEarnScreen':
      screen = MobileLearnEarnScreen();
      break;
    case 'MobileAlphaEventsScreen':
      screen = MobileNewListingScreen();
      break;
    case 'MobileSpotScreen':
      screen = MobileSpotScreen();
      break;
    case 'MobileAlphaScreen':
      screen = MobileAlphaScreen();
      break;
    case 'MobileFuturesScreen':
      screen = MobileFuturesScreen();
      break;
    case 'MobileCopyTradingScreen':
      screen = MobileCopyTradingScreen();
      break;
    case 'MobileOTCScreen':
      screen = MobileOtcScreen();
      break;
    case 'MobileP2PScreen':
      screen = MobileP2pScreen();
      break;
    case 'MobileOptionsScreen':
      screen = MobileOptionsScreen();
      break;
    case 'MobileEarnScreen':
      screen = MobileEarnScreen();
      break;
    case 'MobileSOLStakingScreen':
      screen = MobileSolStakingScreen();
      break;
    case 'MobileSmartArbitrageScreen':
      screen = SmartArbitrageScreen();
      break;
    case 'MobileYieldArenaScreen':
      screen = MobileYieldArenaScreen();
      break;
    case 'MobileDiscountBuyScreen':
      screen = MobileDiscountBuyScreen();
      break;
    case 'MobileRWUSDScreen':
      screen = MobileRWUSDScreen();
      break;
    case 'MobileBFUSDScreen':
      screen = MobileRWUSDScreen();
      break;
    case 'MobileSoftStakingScreen':
      screen = MobileSoftStakingScreen();
      break;
    case 'MobileSimpleEarnScreen':
      screen = MobileSimpleEarnScreen();
      break;
    case 'MobileETHStakingScreen':
      screen = MobileEthStakingScreen();
      break;
    case 'MobileDualInvestmentScreen':
      screen = MobileDualInvestScreen();
      break;
    case 'MobileLoansScreen':
      screen = MobileLoanScreen();
      break;
    case 'MobileShariaEarnScreen':
      screen = MobileShariaScreen();
      break;
    case 'MobileSquareScreen':
      screen = MobileSquareScreen();
      break;
    case 'MobileDepositWithdrawalScreen':
      screen = MobileDepWithStatusScreen();
      break;
    case 'MobileCustomerServiceScreen':
      screen = MobileCustomerServiceScreen();
      break;
    default:
      return; // Do nothing if screen not found
  }
  
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

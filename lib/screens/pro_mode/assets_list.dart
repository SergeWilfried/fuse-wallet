import 'package:digitalrand/utils/format.dart';
import 'package:digitalrand/utils/transaction_row.dart';
import 'package:redux/redux.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:digitalrand/models/app_state.dart';
import 'package:digitalrand/models/tokens/token.dart';
import 'package:digitalrand/screens/pro_mode/token_tile.dart';
import 'package:digitalrand/utils/addresses.dart';
import 'package:digitalrand/models/community/community.dart';

String getTokenUrl(tokenAddress) {
  return tokenAddress == zeroAddress
      ? 'https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/ethereum/info/logo.png'
      : "https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/ethereum/assets/$tokenAddress/logo.png";
}

class AssetsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _AssetsListViewModel>(
      distinct: true,
      converter: _AssetsListViewModel.fromStore,
      builder: (_, viewModel) {
        return Scaffold(
            key: key,
            body: Column(children: <Widget>[
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      itemCount: viewModel.tokens?.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return TokenTile(token: viewModel.tokens[index]);
                      })),
            ]));
      },
    );
  }
}

class _AssetsListViewModel extends Equatable {
  final String walletAddress;
  final List<Token> tokens;

  _AssetsListViewModel({
    this.walletAddress,
    this.tokens,
  });

  static _AssetsListViewModel fromStore(Store<AppState> store) {
    List<Community> communities =
        store.state.cashWalletState.communities.values.toList();
    List<Token> foreignTokens = List<Token>.from(
            store.state.proWalletState.erc20Tokens?.values ?? Iterable.empty())
        .where((Token token) =>
            num.parse(formatValue(token.amount, token.decimals,
                    withPrecision: true))
                .compareTo(0) ==
            1)
        .toList();

    List<Token> homeTokens = communities
        .map((Community community) => community.token
            .copyWith(imageUrl: getIPFSImageUrl(community.metadata.image)))
        .toList();
    return _AssetsListViewModel(
      walletAddress: store.state.userState.walletAddress,
      tokens: [...homeTokens, ...foreignTokens]..sort((tokenA, tokenB) =>
          (tokenB?.amount ?? BigInt.one)
              ?.compareTo(tokenA?.amount ?? BigInt.zero)),
    );
  }

  @override
  List<Object> get props => [walletAddress, tokens];
}

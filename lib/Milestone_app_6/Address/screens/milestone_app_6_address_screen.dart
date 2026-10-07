import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/data/address_storage/address_storage.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/methods/address_screen_logic.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/address_screen/address_widgets_empty_state..dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/address_screen/address_widgets_loading.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/address_screen/address_widgets_location_actions.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/address_screen/address_widgets_saved_address_card.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/address_screen/address_widgets_search_bar.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/widgets/address_screen/address_widgets_section_title.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../state/milestone_app_6_state.dart';

class MilestoneApp6AddressScreen extends StatefulWidget {
  final MilestoneApp6State state;

  const MilestoneApp6AddressScreen({
    super.key,
    required this.state,
  });

  @override
  State<MilestoneApp6AddressScreen> createState() =>
      _MilestoneApp6AddressScreenState();
}

class _MilestoneApp6AddressScreenState
    extends State<MilestoneApp6AddressScreen> {
  late AddressScreenLogic _logic;

  @override
  void initState() {
    super.initState();

    _logic = AddressScreenLogic(
      context: context,
      state: widget.state,
      onChanged: () {
        if (mounted) {
          setState(() {});
        }
      },
    );

    _logic.initialize();
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            14,
            4,
            14,
            30,
          ),
          children: [
            _buildSearchBar(),

            const SizedBox(height: 20),

            _buildLocationActions(),

            const SizedBox(height: 24),

            _buildAddressContent(),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // APP BAR
  // ------------------------------------------------------------

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,

      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
        ),
        onPressed: () {
          context.pop();
        },
      ),

      title: const Text(
        'Select a location',
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w800,
        ),
      ),

      titleSpacing: 0,
    );
  }

  // ------------------------------------------------------------
  // SEARCH BAR
  // ------------------------------------------------------------

  Widget _buildSearchBar() {
    return AddressWidgetsSearchBar(
      controller: _logic.searchController,
      onClear: _logic.clearSearch,
    );
  }

  // ------------------------------------------------------------
  // LOCATION ACTIONS
  // ------------------------------------------------------------

  Widget _buildLocationActions() {
    return AddressWidgetsLocationActions(
      onCurrentLocation: _logic.useCurrentLocation,
      onAddAddress: _logic.addAddress,
      isLoadingLocation: _logic.isLoadingLocation,
      isSavingAddress: _logic.isSavingAddress,
      canAdd: _logic.savedAddresses.length < 3,
    );
  }

  // ------------------------------------------------------------
  // ADDRESS CONTENT
  // ------------------------------------------------------------

  Widget _buildAddressContent() {
    if (_logic.isLoadingAddresses) {
      return const AddressWidgetsLoading();
    }

    if (_logic.filteredAddresses.isEmpty) {
      return const AddressWidgetsEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AddressWidgetsSectionTitle(
          title: 'SAVED ADDRESSES',
        ),

        const SizedBox(height: 12),

        ..._buildAddressCards(),
      ],
    );
  }

  // ------------------------------------------------------------
  // ADDRESS CARDS
  // ------------------------------------------------------------

  List<Widget> _buildAddressCards() {
    return _logic.filteredAddresses.map(
          (address) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
          ),
          child: AddressWidgetsSavedAddressCard(
            address: address,

            isSelected:
            AddressStorage.selectedAddressId ==
                address.id,

            canDelete:
            _logic.savedAddresses.length > 1,

            onSelect: () {
              _logic.selectAddress(address);
            },

            onEdit: () {
              _logic.editAddress(address);
            },

            onDelete: () {
              _logic.deleteAddress(address);
            },
          ),
        );
      },
    ).toList();
  }
}
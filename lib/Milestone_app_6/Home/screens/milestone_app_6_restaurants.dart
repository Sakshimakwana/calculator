import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../Address/data/address_storage/address_storage.dart';
import '../../Login/auth_storage/auth_storage.dart';
import '../data/service/milestone_app_6_restaurant_api.dart';
import '../data/milestone_app_6_restaurants_data.dart';
import '../../state/milestone_app_6_state.dart';
import '../widgets/RestaurantShimmerCard.dart';
import '../widgets/milestone_app_6_restaurant_list_card.dart';

class MilestoneApp6RestaurantsScreen extends StatefulWidget {
final MilestoneApp6State state;

const MilestoneApp6RestaurantsScreen({
super.key,
required this.state,
});

@override
State<MilestoneApp6RestaurantsScreen> createState() =>
_MilestoneApp6RestaurantsScreenState();
}

class _MilestoneApp6RestaurantsScreenState
extends State<MilestoneApp6RestaurantsScreen> {
// ================================================================
// API
// ================================================================

final MilestoneApp6RestaurantApi _restaurantApi =
MilestoneApp6RestaurantApi();

// ================================================================
// RESTAURANTS
// ================================================================

final List<MilestoneApp6Restaurant> _restaurants =
<MilestoneApp6Restaurant>[];

// ================================================================
// LOADING
// ================================================================

bool _isLoadingRestaurants = true;

bool _isLoadingMoreRestaurants = false;

String? _restaurantError;

// ================================================================
// PAGINATION
// ================================================================

static const int _restaurantPerPage = 10;

int _currentRestaurantPage = 0;

int _lastRestaurantPage = 1;

int _totalRestaurants = 0;

int _recordsLoaded = 0;

bool _hasMoreRestaurantPages = true;

// ================================================================
// SCROLL
// ================================================================

final ScrollController _scrollController =
ScrollController();

// ================================================================
// INIT
// ================================================================

@override
void initState() {
super.initState();

_scrollController.addListener(
_onScroll,
);

_loadRestaurants();
}

// ================================================================
// DISPOSE
// ================================================================

@override
void dispose() {
_scrollController.removeListener(
_onScroll,
);

_scrollController.dispose();

super.dispose();
}

// ================================================================
// SCROLL LISTENER
// ================================================================

void _onScroll() {
if (!_scrollController.hasClients) {
return;
}

final position =
_scrollController.position;

// Load next page when user is close to bottom.
if (position.pixels >=
position.maxScrollExtent - 300) {
_loadNextRestaurantPage();
}
}

// ================================================================
// LOAD FIRST PAGE
// ================================================================

Future<void> _loadRestaurants() async {
if (!mounted) {
return;
}

setState(() {
// --------------------------------------------------------------
// FIRST LOAD SHIMMER
// --------------------------------------------------------------

_isLoadingRestaurants = true;
_restaurantError = null;

_restaurants.clear();

_currentRestaurantPage = 0;
_lastRestaurantPage = 1;

_totalRestaurants = 0;
_recordsLoaded = 0;

_hasMoreRestaurantPages = true;
_isLoadingMoreRestaurants = false;
});

try {
// --------------------------------------------------------------
// TOKEN
// --------------------------------------------------------------

final String? token =
await AuthStorage.token;

if (token == null ||
token.trim().isEmpty) {
throw Exception(
'Authentication token is missing. Please login again.',
);
}

// --------------------------------------------------------------
// ADDRESS
// --------------------------------------------------------------

final int? addressId =
await AddressStorage.selectedAddressId;

if (addressId == null ||
addressId <= 0) {
throw Exception(
'Please select an address first.',
);
}

// --------------------------------------------------------------
// API
// --------------------------------------------------------------

debugPrint(
'========================================',
);

debugPrint(
'RESTAURANTS SCREEN API',
);

debugPrint(
'ADDRESS ID: $addressId',
);

debugPrint(
'PAGE: 1',
);

debugPrint(
'========================================',
);

final response =
await _restaurantApi
    .fetchNearbyRestaurantsPage(
token: token,
addressId: addressId,
page: 1,
perPage: _restaurantPerPage,
openNow: false,
includeMenus: true,
);

// --------------------------------------------------------------
// CONVERT API DATA
// --------------------------------------------------------------

final List<MilestoneApp6Restaurant>
apiRestaurants =
response.data
    .map(
(json) =>
MilestoneApp6Restaurant
    .fromJson(
json,
),
)
    .toList();

if (!mounted) {
return;
}

// --------------------------------------------------------------
// UPDATE FIRST PAGE
// --------------------------------------------------------------

setState(() {
_restaurants.addAll(
apiRestaurants,
);

_currentRestaurantPage =
response.currentPage;

_lastRestaurantPage =
response.lastPage;

_totalRestaurants =
response.total;

_recordsLoaded =
response.recordsLoaded;

_hasMoreRestaurantPages =
response.hasMorePages;

// ------------------------------------------------------------
// HIDE FIRST-LOAD SHIMMER
// ------------------------------------------------------------

_isLoadingRestaurants = false;

_restaurantError = null;
});

debugPrint(
'RESTAURANTS LOADED: ${apiRestaurants.length}',
);

debugPrint(
'PAGE: ${response.currentPage}',
);

debugPrint(
'LAST PAGE: ${response.lastPage}',
);

debugPrint(
'TOTAL: ${response.total}',
);

debugPrint(
'RECORDS LOADED: ${response.recordsLoaded}',
);

debugPrint(
'HAS MORE: ${response.hasMorePages}',
);
} catch (e) {
debugPrint(
'RESTAURANT API ERROR: $e',
);

if (!mounted) {
return;
}

setState(() {
_isLoadingRestaurants = false;

_restaurantError =
e.toString();

_restaurants.clear();

_hasMoreRestaurantPages =
false;
});
}
}

// ================================================================
// LOAD NEXT PAGE
// ================================================================

Future<void> _loadNextRestaurantPage() async {
if (_isLoadingMoreRestaurants ||
!_hasMoreRestaurantPages ||
_isLoadingRestaurants) {
return;
}

setState(() {
// --------------------------------------------------------------
// PAGINATION SHIMMER
// --------------------------------------------------------------

_isLoadingMoreRestaurants = true;
});

try {
// --------------------------------------------------------------
// TOKEN
// --------------------------------------------------------------

final String? token =
await AuthStorage.token;

// --------------------------------------------------------------
// ADDRESS
// --------------------------------------------------------------

final int? addressId =
await AddressStorage.selectedAddressId;

if (token == null ||
token.trim().isEmpty ||
addressId == null ||
addressId <= 0) {
if (!mounted) {
return;
}

setState(() {
_isLoadingMoreRestaurants = false;
_hasMoreRestaurantPages = false;
});

return;
}

final int nextPage =
_currentRestaurantPage + 1;

// --------------------------------------------------------------
// LAST PAGE CHECK
// --------------------------------------------------------------

if (nextPage >
_lastRestaurantPage) {
if (!mounted) {
return;
}

setState(() {
_hasMoreRestaurantPages = false;
_isLoadingMoreRestaurants = false;
});

return;
}

// --------------------------------------------------------------
// DEBUG
// --------------------------------------------------------------

debugPrint(
'========================================',
);

debugPrint(
'LOADING NEXT RESTAURANT PAGE',
);

debugPrint(
'PAGE: $nextPage',
);

debugPrint(
'========================================',
);

// --------------------------------------------------------------
// API
// --------------------------------------------------------------

final response =
await _restaurantApi
    .fetchNearbyRestaurantsPage(
token: token,
addressId: addressId,
page: nextPage,
perPage: _restaurantPerPage,
openNow: false,
includeMenus: true,
);

// --------------------------------------------------------------
// CONVERT API DATA
// --------------------------------------------------------------

final List<MilestoneApp6Restaurant>
newRestaurants =
response.data
    .map(
(json) =>
MilestoneApp6Restaurant
    .fromJson(
json,
),
)
    .toList();

if (!mounted) {
return;
}

// --------------------------------------------------------------
// ADD NEW RESTAURANTS
// --------------------------------------------------------------

setState(() {
_restaurants.addAll(
newRestaurants,
);

_currentRestaurantPage =
response.currentPage;

_lastRestaurantPage =
response.lastPage;

_totalRestaurants =
response.total;

_recordsLoaded =
response.recordsLoaded;

_hasMoreRestaurantPages =
response.hasMorePages;

// ------------------------------------------------------------
// HIDE PAGINATION SHIMMER
// ------------------------------------------------------------

_isLoadingMoreRestaurants = false;
});

debugPrint(
'NEW RESTAURANTS: ${newRestaurants.length}',
);

debugPrint(
'CURRENT PAGE: $_currentRestaurantPage',
);

debugPrint(
'LAST PAGE: $_lastRestaurantPage',
);

debugPrint(
'TOTAL: $_totalRestaurants',
);

debugPrint(
'HAS MORE: $_hasMoreRestaurantPages',
);
} catch (e) {
debugPrint(
'NEXT PAGE ERROR: $e',
);

if (!mounted) {
return;
}

setState(() {
_isLoadingMoreRestaurants = false;
});
}
}

// ================================================================
// REFRESH
// ================================================================

Future<void> _refreshRestaurants() async {
await _loadRestaurants();
}

// ================================================================
// OPEN RESTAURANT
// ================================================================

void _openRestaurant(
BuildContext context,
MilestoneApp6Restaurant restaurant,
) {
// IMPORTANT:
// Pass the actual API restaurant object.
//
// Do NOT navigate using restaurant name.
// Do NOT search a static restaurants list.

context.push(
'/restaurant-info',
extra: <String, dynamic>{
'restaurant': restaurant,
},
);
}

// ================================================================
// BUILD
// ================================================================

@override
Widget build(BuildContext context) {
final theme =
Theme.of(context);

final width =
MediaQuery.sizeOf(context).width;

final isTablet =
width >= 700;

return Scaffold(
appBar: AppBar(
elevation: 0,
title: const Text(
'Popular Restaurants',
style: TextStyle(
fontWeight: FontWeight.w700,
),
),
),
body: _buildBody(
context,
theme,
isTablet,
),
);
}

// ================================================================
// BODY
// ================================================================

Widget _buildBody(
BuildContext context,
ThemeData theme,
bool isTablet,
) {
// --------------------------------------------------------------
// INITIAL LOADING
// --------------------------------------------------------------

if (_isLoadingRestaurants &&
_restaurants.isEmpty) {
return const MilestoneApp6RestaurantShimmer(
itemCount: 6,
);
}

// --------------------------------------------------------------
// ERROR
// --------------------------------------------------------------

if (_restaurantError != null &&
_restaurants.isEmpty) {
return RefreshIndicator(
onRefresh: _refreshRestaurants,
child: ListView(
physics:
const AlwaysScrollableScrollPhysics(),
children: [
SizedBox(
height:
MediaQuery.sizeOf(context)
    .height *
0.65,
child: Center(
child: Padding(
padding:
const EdgeInsets.all(24),
child: Column(
mainAxisSize:
MainAxisSize.min,
children: [
const Icon(
Icons
    .error_outline_rounded,
size: 56,
color: Colors.red,
),

const SizedBox(
height: 16,
),

const Text(
'Unable to load restaurants',
textAlign:
TextAlign.center,
style: TextStyle(
fontSize: 18,
fontWeight:
FontWeight.w700,
),
),

const SizedBox(
height: 8,
),

Text(
_restaurantError!
    .replaceFirst(
'Exception: ',
'',
),
textAlign:
TextAlign.center,
style: TextStyle(
color:
theme.hintColor,
fontSize: 13,
),
),

const SizedBox(
height: 20,
),

FilledButton(
onPressed:
_loadRestaurants,
child:
const Text(
'Retry',
),
),
],
),
),
),
),
],
),
);
}

// --------------------------------------------------------------
// EMPTY
// --------------------------------------------------------------

if (_restaurants.isEmpty) {
return RefreshIndicator(
onRefresh: _refreshRestaurants,
child: ListView(
physics:
const AlwaysScrollableScrollPhysics(),
children: [
SizedBox(
height:
MediaQuery.sizeOf(context)
    .height *
0.65,
child: const Center(
child: Text(
'No restaurants found.',
),
),
),
],
),
);
}

// --------------------------------------------------------------
// API RESTAURANTS
// --------------------------------------------------------------

return RefreshIndicator(
onRefresh: _refreshRestaurants,

child: GridView.builder(
controller:
_scrollController,

physics:
const AlwaysScrollableScrollPhysics(),

padding:
EdgeInsets.fromLTRB(
isTablet ? 24 : 16,
16,
isTablet ? 24 : 16,
24,
),

gridDelegate:
SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount:
isTablet ? 3 : 1,

crossAxisSpacing: 16,

mainAxisSpacing: 16,

mainAxisExtent:
isTablet ? 135 : 115,
),

// ------------------------------------------------------------
// ADD ONE EXTRA ITEM ONLY DURING PAGINATION
// ------------------------------------------------------------

itemCount:
_restaurants.length +
(_isLoadingMoreRestaurants
? 1
    : 0),

itemBuilder:
(context, index) {
// ----------------------------------------------------------
// PAGINATION SHIMMER
// ----------------------------------------------------------

if (index >=
_restaurants.length) {
return const MilestoneApp6RestaurantShimmer();
}

// ----------------------------------------------------------
// RESTAURANT
// ----------------------------------------------------------

final restaurant =
_restaurants[index];

// ----------------------------------------------------------
// RESTAURANT CARD
// ----------------------------------------------------------

return _buildRestaurantCard(
context,
theme,
restaurant,
);
},
),
);
}

// ================================================================
// RESTAURANT CARD
// ================================================================

Widget _buildRestaurantCard(
BuildContext context,
ThemeData theme,
MilestoneApp6Restaurant restaurant,
) {
return Stack(
children: [
// ------------------------------------------------------------
// CARD
// ------------------------------------------------------------

Positioned.fill(
child:
MilestoneApp6RestaurantListCard(
restaurant: restaurant,

onTap: () {
_openRestaurant(
context,
restaurant,
);
},
),
),

// ------------------------------------------------------------
// FAVORITE
// ------------------------------------------------------------

Positioned(
top: 8,
right: 8,
child: Material(
color: Colors.transparent,

child: InkWell(
onTap: () {
widget.state
    .toggleRestaurantSaved(
restaurant.name,
);
},

borderRadius:
BorderRadius.circular(30),

child:
AnimatedBuilder(
animation: widget.state,

builder:
(context, child) {
final isFavorite =
widget.state
    .isRestaurantSaved(
restaurant.name,
);

return AnimatedContainer(
duration:
const Duration(
milliseconds: 180,
),

curve:
Curves.easeOut,

width: 34,
height: 34,

decoration:
BoxDecoration(
color:
theme.brightness ==
Brightness.dark
? const Color(
0xFF303030,
)
    : Colors.white,

shape:
BoxShape.circle,

border:
Border.all(
color:
theme.brightness ==
Brightness.dark
? Colors.white
    .withOpacity(
0.08,
)
    : const Color(
0xFFE5E5E5,
),
),

boxShadow: [
BoxShadow(
color:
Colors.black
    .withOpacity(
0.08,
),
blurRadius: 6,
offset:
const Offset(
0,
2,
),
),
],
),

child:
AnimatedSwitcher(
duration:
const Duration(
milliseconds: 180,
),

transitionBuilder:
(
child,
animation,
) {
return ScaleTransition(
scale:
animation,
child:
child,
);
},

child: Icon(
isFavorite
? Icons
    .favorite_rounded
    : Icons
    .favorite_border_rounded,

key: ValueKey(
isFavorite,
),

size: 19,

color: isFavorite
? Colors.red
    : theme
    .iconTheme
    .color
    ?.withOpacity(
0.65,
),
),
),
);
},
),
),
),
),

// ------------------------------------------------------------
// ARROW
// ------------------------------------------------------------

Positioned(
right: 10,
bottom: 10,
child: Material(
color:
Colors.transparent,

child: InkWell(
onTap: () {
_openRestaurant(
context,
restaurant,
);
},

borderRadius:
BorderRadius.circular(
30,
),

child: Container(
width: 28,
height: 28,

decoration:
BoxDecoration(
color:
theme.brightness ==
Brightness.dark
? const Color(
0xFF303030,
)
    : const Color(
0xFFF5F5F5,
),

shape:
BoxShape.circle,
),

child: Icon(
Icons
    .chevron_right_rounded,

size: 21,

color: theme
    .iconTheme
    .color
    ?.withOpacity(
0.65,
),
),
),
),
),
),
],
);
}
}


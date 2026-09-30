
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:app_matic_tech_flutter_app/core/constants/api_constants.dart';
import 'package:app_matic_tech_flutter_app/core/storage/auth_storage.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/data/milestone_app_6_restaurants_data.dart';
import 'package:app_matic_tech_flutter_app/models/restaurant_menu_model.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/state/milestone_app_6_state.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/widgets/milestone_app_6_image.dart';

class MilestoneApp6RestaurantInfoScreen extends StatefulWidget {
final MilestoneApp6Restaurant restaurant;
final MilestoneApp6State state;

const MilestoneApp6RestaurantInfoScreen({
super.key,
required this.restaurant,
required this.state,
});

@override
State<MilestoneApp6RestaurantInfoScreen> createState() =>
_MilestoneApp6RestaurantInfoScreenState();
}

class _MilestoneApp6RestaurantInfoScreenState
extends State<MilestoneApp6RestaurantInfoScreen> {
bool _isLoading = true;
String? _errorMessage;

List<RestaurantMenu> _menus = [];

@override
void initState() {
super.initState();
_loadRestaurantMenu();
}

Future<void> _loadRestaurantMenu() async {
if (!mounted) return;

setState(() {
_isLoading = true;
_errorMessage = null;
});

try {
final String? token = await AuthStorage.token;

if (token == null || token.trim().isEmpty) {
throw Exception('Authentication token is missing. Please login again.');
}

if (widget.restaurant.id <= 0) {
throw Exception(
'Invalid restaurant ID. The restaurant must come from the restaurant API.',
);
}

final Uri uri = Uri.parse(
'${ApiConstants.baseUrl}'
'${ApiConstants.restaurantMenus(widget.restaurant.id)}',
);

debugPrint('========================================');
debugPrint('RESTAURANT MENU API');
debugPrint('Restaurant ID: ${widget.restaurant.id}');
debugPrint('Restaurant: ${widget.restaurant.name}');
debugPrint('URL: $uri');
debugPrint('========================================');

final http.Response response = await http
    .get(
uri,
headers: {
'Authorization': 'Bearer $token',
'Accept': 'application/json',
'Content-Type': 'application/json',
},
)
    .timeout(const Duration(seconds: 30));

debugPrint('MENU STATUS: ${response.statusCode}');
debugPrint('MENU RESPONSE: ${response.body}');

if (response.statusCode == 401) {
throw Exception('Unauthorized. Please login again.');
}

if (response.statusCode == 404) {
throw Exception(
'Menu not found for ${widget.restaurant.name}.',
);
}

if (response.statusCode < 200 ||
response.statusCode >= 300) {
throw Exception(
'Menu API failed. Status: ${response.statusCode}',
);
}

if (response.body.trim().isEmpty) {
if (!mounted) return;

setState(() {
_menus = [];
_isLoading = false;
});

return;
}

final dynamic decoded = jsonDecode(response.body);

if (decoded is! Map<String, dynamic>) {
throw Exception('Invalid menu API response.');
}

final RestaurantMenuResponse menuResponse =
RestaurantMenuResponse.fromJson(decoded);

if (!mounted) return;

setState(() {
_menus = menuResponse.data;
_isLoading = false;
});

for (final RestaurantMenu menu in _menus) {
debugPrint('CATEGORY: ${menu.name}');

for (final RestaurantMenuItem item in menu.menuItems) {
debugPrint(
'FOOD: ${item.name} - ${item.price} - '
'available: ${item.availability}',
);
}
}
} catch (e) {
debugPrint('RESTAURANT MENU ERROR: $e');

if (!mounted) return;

setState(() {
_isLoading = false;
_errorMessage = e.toString();
});
}
}

Future<void> _refreshMenu() async {
await _loadRestaurantMenu();
}

int get _foodCount {
int count = 0;

for (final RestaurantMenu menu in _menus) {
count += menu.menuItems.length;
}

return count;
}

@override
Widget build(BuildContext context) {
final ThemeData theme = Theme.of(context);
final double width = MediaQuery.sizeOf(context).width;
final bool isTablet = width >= 700;

return Scaffold(
body: RefreshIndicator(
onRefresh: _refreshMenu,
child: CustomScrollView(
physics: const AlwaysScrollableScrollPhysics(),
slivers: [
_buildHeader(
context,
theme,
isTablet,
),
_buildMenuContent(
context,
theme,
isTablet,
),
],
),
),
);
}

SliverAppBar _buildHeader(
BuildContext context,
ThemeData theme,
bool isTablet,
) {
return SliverAppBar(
expandedHeight: isTablet ? 300 : 270,
pinned: true,
backgroundColor: theme.scaffoldBackgroundColor,
surfaceTintColor: Colors.transparent,
leading: Padding(
padding: const EdgeInsets.all(8),
child: CircleAvatar(
backgroundColor: theme.colorScheme.surface,
child: IconButton(
icon: const Icon(Icons.arrow_back_rounded),
onPressed: () {
context.pop();
},
),
),
),
flexibleSpace: FlexibleSpaceBar(
background: Stack(
fit: StackFit.expand,
children: [
MilestoneApp6Image(
url: widget.restaurant.image,
fit: BoxFit.cover,
borderRadius: BorderRadius.zero,
),
Positioned.fill(
child: DecoratedBox(
decoration: BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
colors: [
Colors.transparent,
Colors.black.withOpacity(.10),
Colors.black.withOpacity(.80),
],
stops: const [
.25,
.55,
1.0,
],
),
),
),
),
Positioned(
left: 20,
right: 20,
bottom: 22,
child: _buildRestaurantInformation(),
),
],
),
),
);
}

Widget _buildRestaurantInformation() {
final bool isOpen = widget.restaurant.isOpen;

return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
widget.restaurant.name,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
color: Colors.white,
fontSize: 25,
fontWeight: FontWeight.w800,
height: 1.1,
shadows: [
Shadow(
color: Colors.black54,
blurRadius: 5,
offset: Offset(0, 2),
),
],
),
),
const SizedBox(height: 7),
Row(
children: [
Text(
isOpen ? 'Open' : 'Closed',
style: TextStyle(
color: isOpen
? Colors.greenAccent
    : Colors.redAccent,
fontSize: 15,
fontWeight: FontWeight.w700,
shadows: const [
Shadow(
color: Colors.black54,
blurRadius: 4,
),
],
),
),
const SizedBox(width: 7),
const Text(
'•',
style: TextStyle(
color: Colors.white,
fontSize: 15,
fontWeight: FontWeight.w700,
),
),
const SizedBox(width: 7),
if (widget.restaurant.distance.isNotEmpty)
Text(
widget.restaurant.distance,
style: const TextStyle(
color: Colors.white,
fontSize: 14,
fontWeight: FontWeight.w600,
shadows: [
Shadow(
color: Colors.black54,
blurRadius: 4,
),
],
),
),
],
),
if (widget.restaurant.cuisine.isNotEmpty) ...[
const SizedBox(height: 7),
Text(
widget.restaurant.cuisine,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
color: Colors.white,
fontSize: 13,
fontWeight: FontWeight.w500,
shadows: [
Shadow(
color: Colors.black54,
blurRadius: 4,
),
],
),
),
],
if (widget.restaurant.address.isNotEmpty) ...[
const SizedBox(height: 5),
Row(
children: [
const Icon(
Icons.location_on_rounded,
color: Colors.white,
size: 15,
),
const SizedBox(width: 4),
Expanded(
child: Text(
widget.restaurant.address,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
color: Colors.white,
fontSize: 12,
fontWeight: FontWeight.w500,
shadows: [
Shadow(
color: Colors.black54,
blurRadius: 4,
),
],
),
),
),
],
),
],
],
);
}

Widget _buildMenuContent(
BuildContext context,
ThemeData theme,
bool isTablet,
) {
if (_isLoading) {
return _buildMenuShimmer(
context,
theme,
isTablet,
);
}

if (_errorMessage != null) {
return SliverFillRemaining(
hasScrollBody: false,
child: _buildErrorState(context),
);
}

if (_menus.isEmpty) {
return SliverFillRemaining(
hasScrollBody: false,
child: _buildEmptyState(context),
);
}

return SliverList(
delegate: SliverChildBuilderDelegate(
(context, index) {
final RestaurantMenu menu = _menus[index];

return _buildCategorySection(
context,
theme,
menu,
isTablet,
);
},
childCount: _menus.length,
),
);
}

// ================================================================
// MENU SHIMMER
// ================================================================

Widget _buildMenuShimmer(
BuildContext context,
ThemeData theme,
bool isTablet,
) {
final bool isDark =
theme.brightness == Brightness.dark;

final Color baseColor = isDark
? const Color(0xFF292929)
    : const Color(0xFFE2E2E2);

final Color highlightColor = isDark
? const Color(0xFF3A3A3A)
    : const Color(0xFFF5F5F5);

return SliverToBoxAdapter(
child: Shimmer.fromColors(
baseColor: baseColor,
highlightColor: highlightColor,
child: Padding(
padding: const EdgeInsets.fromLTRB(
16,
18,
16,
24,
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
_buildShimmerCategoryHeader(),
const SizedBox(height: 14),

_buildShimmerFoodGrid(
isTablet,
),

const SizedBox(height: 24),

_buildShimmerCategoryHeader(),
const SizedBox(height: 14),

_buildShimmerFoodGrid(
isTablet,
),

const SizedBox(height: 24),

_buildShimmerCategoryHeader(),
const SizedBox(height: 14),

_buildShimmerFoodGrid(
isTablet,
),
],
),
),
),
);
}

Widget _buildShimmerCategoryHeader() {
return Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Row(
children: [
Container(
width: 21,
height: 21,
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(6),
),
),
const SizedBox(width: 8),
Expanded(
child: Container(
height: 18,
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(6),
),
),
),
],
),
const SizedBox(height: 8),
Container(
width: 100,
height: 13,
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(5),
),
),
],
);
}

Widget _buildShimmerFoodGrid(
bool isTablet,
) {
final int crossAxisCount =
isTablet ? 4 : 2;

return GridView.builder(
shrinkWrap: true,
physics:
const NeverScrollableScrollPhysics(),
itemCount: isTablet ? 4 : 4,
gridDelegate:
SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: crossAxisCount,
crossAxisSpacing: 12,
mainAxisSpacing: 14,
mainAxisExtent:
isTablet ? 300 : 245,
),
itemBuilder: (context, index) {
return _buildShimmerFoodCard();
},
);
}

Widget _buildShimmerFoodCard() {
return Container(
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(16),
),
clipBehavior: Clip.antiAlias,
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Container(
height: 125,
width: double.infinity,
color: Colors.white,
),

Expanded(
child: Padding(
padding:
const EdgeInsets.fromLTRB(
12,
10,
12,
12,
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Container(
width: double.infinity,
height: 15,
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(5),
),
),

const SizedBox(height: 7),

Container(
width: 80,
height: 14,
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(5),
),
),

const Spacer(),

Container(
width: 65,
height: 15,
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(5),
),
),

const SizedBox(height: 7),

Container(
width: double.infinity,
height: 34,
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(10),
),
),
],
),
),
),
],
),
);
}

Widget _buildCategorySection(
BuildContext context,
ThemeData theme,
RestaurantMenu menu,
bool isTablet,
) {
return Padding(
padding: const EdgeInsets.fromLTRB(
16,
18,
16,
0,
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
Icon(
Icons.restaurant_menu_rounded,
size: 21,
color: theme.colorScheme.primary,
),
const SizedBox(width: 8),
Expanded(
child: Text(
menu.name,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w800,
color: theme.colorScheme.onSurface,
),
),
),
],
),
const SizedBox(height: 4),
Text(
'${menu.menuItems.length} Food Items',
style: TextStyle(
color: theme.hintColor,
fontSize: 13,
fontWeight: FontWeight.w500,
),
),
if (menu.menuItems.isEmpty)
Padding(
padding: const EdgeInsets.only(
top: 14,
bottom: 8,
),
child: Text(
'No food items available in this category.',
style: TextStyle(
color: theme.hintColor,
),
),
)
else
Padding(
padding: const EdgeInsets.only(
top: 12,
bottom: 6,
),
child: GridView.builder(
shrinkWrap: true,
physics: const NeverScrollableScrollPhysics(),
itemCount: menu.menuItems.length,
gridDelegate:
SliverGridDelegateWithFixedCrossAxisCount(
crossAxisCount: isTablet ? 4 : 2,
crossAxisSpacing: 12,
mainAxisSpacing: 14,
mainAxisExtent: isTablet ? 300 : 245,
),
itemBuilder: (context, index) {
final RestaurantMenuItem item =
menu.menuItems[index];

return _buildFoodCard(
context,
theme,
item,
);
},
),
),
],
),
);
}

Widget _buildFoodCard(
BuildContext context,
ThemeData theme,
RestaurantMenuItem item,
) {
final bool available =
item.availability && widget.restaurant.isOpen;

final bool isDark =
theme.brightness == Brightness.dark;

final Color cardColor = isDark
? const Color(0xFF202020)
    : theme.colorScheme.surface;

final Color titleColor = isDark
? Colors.white
    : const Color(0xFF171717);

final Color secondaryColor = isDark
? const Color(0xFFBDBDBD)
    : const Color(0xFF666666);

return Container(
decoration: BoxDecoration(
color: cardColor,
borderRadius: BorderRadius.circular(16),
border: isDark
? Border.all(
color: Colors.white.withOpacity(.06),
)
    : null,
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(
isDark ? .25 : .06,
),
blurRadius: 10,
offset: const Offset(0, 4),
),
],
),
clipBehavior: Clip.antiAlias,
child: InkWell(
onTap: available
? () {
context.push(
'/food/${item.id}',
);
}
    : null,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
SizedBox(
height: 125,
width: double.infinity,
child: Stack(
fit: StackFit.expand,
children: [
MilestoneApp6Image(
url: item.imageUrl,
width: double.infinity,
fit: BoxFit.cover,
borderRadius: BorderRadius.zero,
),
if (!available)
Container(
color: Colors.black.withOpacity(.45),
alignment: Alignment.center,
child: Text(
widget.restaurant.isOpen
? 'Unavailable'
    : 'Restaurant Closed',
textAlign: TextAlign.center,
style: const TextStyle(
color: Colors.white,
fontWeight: FontWeight.w700,
fontSize: 13,
),
),
),
],
),
),
Expanded(
child: Padding(
padding: const EdgeInsets.fromLTRB(
12,
10,
12,
12,
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
item.name,
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: TextStyle(
color: titleColor,
fontSize: 15,
fontWeight: FontWeight.w700,
),
),
const Spacer(),
Text(
item.price <= 0
? '₹0'
    : '₹${_formatPrice(item.price)}',
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(
color: titleColor,
fontSize: 15,
fontWeight: FontWeight.w700,
),
),
const SizedBox(height: 7),
SizedBox(
width: double.infinity,
height: 34,
child: DecoratedBox(
decoration: BoxDecoration(
color: available
? theme.colorScheme.primary
    : Colors.grey.withOpacity(.25),
borderRadius:
BorderRadius.circular(10),
),
child: Center(
child: Text(
available
? 'Add to cart'
    : 'Unavailable',
style: TextStyle(
color: available
? Colors.white
    : secondaryColor,
fontSize: 11,
fontWeight: FontWeight.w700,
),
),
),
),
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

String _formatPrice(double price) {
if (price == price.roundToDouble()) {
return price.toInt().toString();
}

return price.toStringAsFixed(2);
}

Widget _buildErrorState(BuildContext context) {
return Center(
child: Padding(
padding: const EdgeInsets.all(30),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
const Icon(
Icons.error_outline_rounded,
size: 55,
color: Colors.red,
),
const SizedBox(height: 14),
const Text(
'Unable to load restaurant menu',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w700,
),
),
const SizedBox(height: 8),
Text(
_errorMessage ?? 'Something went wrong.',
textAlign: TextAlign.center,
),
const SizedBox(height: 18),
ElevatedButton(
onPressed: _loadRestaurantMenu,
child: const Text('Retry'),
),
],
),
),
);
}

Widget _buildEmptyState(BuildContext context) {
return Center(
child: Padding(
padding: const EdgeInsets.all(30),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
Icons.restaurant_menu_outlined,
size: 55,
color: Theme.of(context)
    .colorScheme
    .primary,
),
const SizedBox(height: 14),
const Text(
'No food items available',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.w700,
),
),
const SizedBox(height: 8),
Text(
'This restaurant does not have menu items available right now.',
textAlign: TextAlign.center,
style: TextStyle(
color: Theme.of(context).hintColor,
),
),
],
),
),
);
}
}


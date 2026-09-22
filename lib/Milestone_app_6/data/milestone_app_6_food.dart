class MilestoneApp6Category {
  final String name;
  final String image;

  const MilestoneApp6Category(
      this.name,
      this.image,
      );
}

class MilestoneApp6Food {
  final String id;
  final String name;
  final String category;
  final String restaurant;
  final String image;
  final double price;
  final String description;
  final bool isAvailable;

  const MilestoneApp6Food({
    required this.id,
    required this.name,
    required this.category,
    required this.restaurant,
    required this.image,
    required this.price,
    required this.description,
    this.isAvailable = true,
  });
}

// ============================================================================
// CATEGORIES
// ============================================================================

const milestoneApp6Categories = <MilestoneApp6Category>[
  MilestoneApp6Category(
    'Pizza',
    'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=400',
  ),

  MilestoneApp6Category(
    'Burger',
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
  ),

  MilestoneApp6Category(
    'Sushi',
    'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=400',
  ),

  MilestoneApp6Category(
    'Dessert',
    'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400',
  ),

  MilestoneApp6Category(
    'Pasta',
    'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=400',
  ),

  MilestoneApp6Category(
    'Salad',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
  ),

  MilestoneApp6Category(
    'Drinks',
    'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400',
  ),

  MilestoneApp6Category(
    'Tacos',
    'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=400',
  ),

  MilestoneApp6Category(
    'Asian',
    'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400',
  ),

  MilestoneApp6Category(
    'Breakfast',
    'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400',
  ),

  MilestoneApp6Category(
    'Sandwich',
    'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=400',
  ),
];


const milestoneApp6Foods = <MilestoneApp6Food>[

  MilestoneApp6Food(
    id: 'margherita',
    name: 'Margherita Pizza',
    category: 'Pizza',
    restaurant: 'The Italian Bistro',
    image:
    'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=900',
    price: 8.99,
    description:
    'Classic delight with fresh tomatoes, mozzarella, basil and olive oil.',
  ),

  MilestoneApp6Food(
    id: 'pepperoni',
    name: 'Pepperoni Pizza',
    category: 'Pizza',
    restaurant: 'Pizza House',
    image:
    'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=900',
    price: 9.99,
    description:
    'Crispy pepperoni, melted mozzarella and rich tomato sauce.',
  ),

  MilestoneApp6Food(
    id: 'veggie',
    name: 'Veggie Pizza',
    category: 'Pizza',
    restaurant: 'Green Oven',
    image:
    'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=900',
    price: 8.49,
    description:
    'Roasted vegetables, mozzarella and herbs on a crisp crust.',
  ),

  MilestoneApp6Food(
    id: 'bbq',
    name: 'BBQ Chicken Pizza',
    category: 'Pizza',
    restaurant: 'Fire Oven',
    image:
    'https://images.unsplash.com/photo-1566843972142-a7fcb70de55a?w=900',
    price: 10.99,
    description:
    'Smoky BBQ chicken, onions and mozzarella with a sweet glaze.',
  ),

  // ==========================================================================
  // BURGER
  // ==========================================================================

  MilestoneApp6Food(
    id: 'classic-burger',
    name: 'Classic Burger',
    category: 'Burger',
    restaurant: 'Burger Hub',
    image:
    'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=900',
    price: 7.99,
    description:
    'Juicy beef patty with lettuce, tomato, cheese and house sauce.',
  ),

  MilestoneApp6Food(
    id: 'cheese-burger',
    name: 'Double Cheese Burger',
    category: 'Burger',
    restaurant: 'Burger Hub',
    image:
    'https://images.unsplash.com/photo-1550547660-d9450f859349?w=900',
    price: 9.49,
    description:
    'Double beef patties with melted cheese, lettuce and special sauce.',
  ),

  MilestoneApp6Food(
    id: 'chicken-burger',
    name: 'Crispy Chicken Burger',
    category: 'Burger',
    restaurant: 'Chicken House',
    image:
    'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=900',
    price: 8.49,
    description:
    'Crunchy chicken fillet with fresh lettuce and creamy sauce.',
  ),

  // ==========================================================================
  // SUSHI
  // ==========================================================================

  MilestoneApp6Food(
    id: 'salmon-sushi',
    name: 'Salmon Sushi',
    category: 'Sushi',
    restaurant: 'Sushi World',
    image:
    'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=900',
    price: 12.99,
    description:
    'Fresh salmon sushi prepared with seasoned rice and delicate toppings.',
  ),

  MilestoneApp6Food(
    id: 'california-roll',
    name: 'California Roll',
    category: 'Sushi',
    restaurant: 'Tokyo Kitchen',
    image:
    'https://images.unsplash.com/photo-1553621042-f6e147245754?w=900',
    price: 10.49,
    description:
    'Classic California roll with crab, avocado, cucumber and sushi rice.',
  ),

  MilestoneApp6Food(
    id: 'tuna-roll',
    name: 'Spicy Tuna Roll',
    category: 'Sushi',
    restaurant: 'Tokyo Kitchen',
    image:
    'https://images.unsplash.com/photo-1617196034183-421b4917c92d?w=900',
    price: 11.49,
    description:
    'Fresh tuna mixed with spicy sauce and rolled with seasoned rice.',
  ),

  MilestoneApp6Food(
    id: 'dragon-roll',
    name: 'Dragon Roll',
    category: 'Sushi',
    restaurant: 'Sushi World',
    image:
    'https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=900',
    price: 13.99,
    description:
    'Premium sushi roll with avocado, shrimp and a flavorful house sauce.',
  ),

  // ==========================================================================
  // DESSERT
  // ==========================================================================

  MilestoneApp6Food(
    id: 'chocolate-cake',
    name: 'Chocolate Cake',
    category: 'Dessert',
    restaurant: 'Sweet Corner',
    image:
    'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=900',
    price: 6.49,
    description:
    'Rich chocolate cake layered with smooth chocolate cream.',
  ),

  MilestoneApp6Food(
    id: 'ice-cream',
    name: 'Vanilla Ice Cream',
    category: 'Dessert',
    restaurant: 'Ice Cream House',
    image:
    'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=900',
    price: 4.99,
    description:
    'Creamy vanilla ice cream served with a sweet topping.',
  ),

  MilestoneApp6Food(
    id: 'donut',
    name: 'Glazed Donut',
    category: 'Dessert',
    restaurant: 'Donut Factory',
    image:
    'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=900',
    price: 3.99,
    description:
    'Soft golden donut covered with a smooth sweet glaze.',
  ),

  MilestoneApp6Food(
    id: 'cheesecake',
    name: 'Classic Cheesecake',
    category: 'Dessert',
    restaurant: 'Sweet Corner',
    image:
    'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=900',
    price: 6.99,
    description:
    'Creamy cheesecake with a buttery biscuit base and berry topping.',
  ),

  // ==========================================================================
  // PASTA
  // ==========================================================================

  MilestoneApp6Food(
    id: 'pasta',
    name: 'Creamy Pasta',
    category: 'Pasta',
    restaurant: 'Pasta Corner',
    image:
    'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=900',
    price: 8.49,
    description:
    'Creamy parmesan sauce tossed with pasta and fresh herbs.',
  ),

  MilestoneApp6Food(
    id: 'carbonara',
    name: 'Spaghetti Carbonara',
    category: 'Pasta',
    restaurant: 'Italian Kitchen',
    image:
    'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=900',
    price: 9.99,
    description:
    'Classic spaghetti with creamy sauce, parmesan and herbs.',
  ),

  MilestoneApp6Food(
    id: 'arrabbiata',
    name: 'Penne Arrabbiata',
    category: 'Pasta',
    restaurant: 'Pasta Corner',
    image:
    'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=900',
    price: 8.99,
    description:
    'Penne pasta tossed in a rich tomato and chili sauce.',
  ),

  // ==========================================================================
  // SALAD
  // ==========================================================================

  MilestoneApp6Food(
    id: 'salad',
    name: 'Garden Salad',
    category: 'Salad',
    restaurant: 'Fresh Bowl',
    image:
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 6.99,
    description:
    'Crisp greens, vegetables and a light house dressing.',
  ),

  MilestoneApp6Food(
    id: 'caesar-salad',
    name: 'Caesar Salad',
    category: 'Salad',
    restaurant: 'Fresh Bowl',
    image:
    'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=900',
    price: 7.99,
    description:
    'Fresh romaine lettuce, parmesan, croutons and Caesar dressing.',
  ),

  MilestoneApp6Food(
    id: 'greek-salad',
    name: 'Greek Salad',
    category: 'Salad',
    restaurant: 'Mediterranean Cafe',
    image:
    'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=900',
    price: 7.49,
    description:
    'Fresh cucumber, tomato, olives, feta cheese and herbs.',
  ),

  MilestoneApp6Food(
    id: 'lemonade',
    name: 'Fresh Lemonade',
    category: 'Drinks',
    restaurant: 'Fresh Drinks',
    image:
    'https://images.unsplash.com/photo-1621263764928-df1444c5e859?w=800&auto=format&fit=crop',
    price: 3.49,
    description:
    'Refreshing lemonade made with fresh lemons and a touch of sweetness.',
  ),

  MilestoneApp6Food(
    id: 'iced-coffee',
    name: 'Iced Coffee',
    category: 'Drinks',
    restaurant: 'Coffee House',
    image:
    'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=900',
    price: 4.49,
    description:
    'Cold brewed coffee served over ice with creamy milk.',
  ),

  MilestoneApp6Food(
    id: 'strawberry-shake',
    name: 'Strawberry Shake',
    category: 'Drinks',
    restaurant: 'Shake Station',
    image:
    'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=900',
    price: 5.49,
    description:
    'Creamy strawberry milkshake topped with fresh berries.',
  ),

  MilestoneApp6Food(
    id: 'orange-juice',
    name: 'Fresh Orange Juice',
    category: 'Drinks',
    restaurant: 'Fresh Drinks',
    image:
    'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=900',
    price: 3.99,
    description:
    'Freshly squeezed orange juice served chilled.',
  ),





  MilestoneApp6Food(
    id: 'fried-rice',
    name: 'Vegetable Fried Rice',
    category: 'Asian',
    restaurant: 'Asian Kitchen',
    image:
    'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=900',
    price: 7.99,
    description:
    'Fragrant fried rice tossed with fresh vegetables and Asian spices.',
  ),

  MilestoneApp6Food(
    id: 'noodles',
    name: 'Asian Noodles',
    category: 'Asian',
    restaurant: 'Asian Kitchen',
    image:
    'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=900',
    price: 8.49,
    description:
    'Stir-fried noodles with vegetables and a savory house sauce.',
  ),

  // ==========================================================================
  // BREAKFAST
  // ==========================================================================

  MilestoneApp6Food(
    id: 'pancakes',
    name: 'Pancake Stack',
    category: 'Breakfast',
    restaurant: 'Morning Cafe',
    image:
    'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=900',
    price: 6.99,
    description:
    'Fluffy pancakes served with berries, syrup and butter.',
  ),

  MilestoneApp6Food(
    id: 'avocado-toast',
    name: 'Avocado Toast',
    category: 'Breakfast',
    restaurant: 'Morning Cafe',
    image:
    'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=900',
    price: 7.49,
    description:
    'Toasted bread topped with creamy avocado and fresh herbs.',
  ),

  MilestoneApp6Food(
    id: 'breakfast-bowl',
    name: 'Healthy Breakfast Bowl',
    category: 'Breakfast',
    restaurant: 'Fresh Bowl',
    image:
    'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?w=900',
    price: 8.49,
    description:
    'A healthy bowl with fruit, yogurt, granola and fresh toppings.',
  ),


  MilestoneApp6Food(
    id: 'paneer-sandwich',
    name: 'Paneer Sandwich',
    category: 'Sandwich',
    restaurant: 'Veggie Corner',
    image:
    'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=900',
    price: 7.49,
    description:
    'Grilled sandwich filled with soft paneer, fresh vegetables, cheese and creamy sauce.',
  ),

  MilestoneApp6Food(
    id: 'grilled-cheese',
    name: 'Grilled Cheese Sandwich',
    category: 'Sandwich',
    restaurant: 'Toast House',
    image:
    'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=900',
    price: 5.99,
    description:
    'Crispy toasted bread filled with melted cheese and a delicious buttery flavor.',
  ),

  MilestoneApp6Food(
    id: 'veg-club-sandwich',
    name: 'Veg Club Sandwich',
    category: 'Sandwich',
    restaurant: 'Fresh Bites',
    image:
    'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 6.99,
    description:
    'Triple-layer sandwich with lettuce, tomato, cucumber, cheese and fresh vegetables.',
  ),

  MilestoneApp6Food(
    id: 'cheese-corn-sandwich',
    name: 'Cheese Corn Sandwich',
    category: 'Sandwich',
    restaurant: 'Veggie Corner',
    image:
    'https://images.unsplash.com/photo-1481070414801-51fd732d7184?w=900',
    price: 6.49,
    description:
    'Toasted sandwich packed with sweet corn, melted cheese and creamy seasoning.',
  ),

  MilestoneApp6Food(
    id: 'avocado-sandwich',
    name: 'Avocado Sandwich',
    category: 'Sandwich',
    restaurant: 'Green Cafe',
    image:
    'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=900',
    price: 7.49,
    description:
    'Fresh avocado with lettuce, tomato and herbs served between toasted bread.',
  ),

  MilestoneApp6Food(
    id: 'vegetable-grilled-sandwich',
    name: 'Vegetable Grilled Sandwich',
    category: 'Sandwich',
    restaurant: 'Fresh Bites',
    image:
    'https://images.unsplash.com/photo-1553909489-cd47e0907980?w=900',
    price: 6.49,
    description:
    'Crispy grilled bread filled with fresh vegetables, cheese and flavorful herbs.',
  ),
  MilestoneApp6Food(
    id: 'veg-tacos',
    name: 'Classic Veg Tacos',
    category: 'Tacos',
    restaurant: 'Mexican Fiesta',
    image:
    'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=900',
    price: 7.49,
    description:
    'Crispy tacos filled with fresh vegetables, black beans, corn, lettuce and salsa.',
  ),

  MilestoneApp6Food(
    id: 'paneer-tacos',
    name: 'Paneer Tacos',
    category: 'Tacos',
    restaurant: 'Mexican Fiesta',
    image:
    'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=900',
    price: 8.49,
    description:
    'Soft tortillas filled with spiced paneer, fresh vegetables, cheese and creamy sauce.',
  ),

  MilestoneApp6Food(
    id: 'avocado-tacos',
    name: 'Avocado Veg Tacos',
    category: 'Tacos',
    restaurant: 'Green Mexican',
    image:
    'https://images.unsplash.com/photo-1615870216519-2f9fa575fa5c?w=900',
    price: 7.99,
    description:
    'Fresh avocado, crunchy vegetables, black beans and cilantro served in soft tortillas.',
  ),

  MilestoneApp6Food(
    id: 'bean-tacos',
    name: 'Mexican Bean Tacos',
    category: 'Tacos',
    restaurant: 'Taco House',
    image:
    'https://images.unsplash.com/photo-1599974579688-8dbdd335c77f?w=900',
    price: 6.99,
    description:
    'Flavorful tacos filled with seasoned beans, lettuce, tomato, corn and fresh salsa.',
  ),

  MilestoneApp6Food(
    id: 'corn-tacos',
    name: 'Cheesy Corn Tacos',
    category: 'Tacos',
    restaurant: 'Taco Corner',
    image:
    'https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?w=900',
    price: 6.49,
    description:
    'Sweet corn, melted cheese, peppers and fresh herbs wrapped in warm tortillas.',
  ),

  MilestoneApp6Food(
    id: 'mushroom-tacos',
    name: 'Mushroom Tacos',
    category: 'Tacos',
    restaurant: 'Veggie Mexican',
    image:
    'https://images.unsplash.com/photo-1624300629298-e9de39c13be5?w=900',
    price: 7.99,
    description:
    'Seasoned mushrooms with lettuce, salsa, avocado and fresh cilantro in crispy tortillas.',
  ),


  // ==========================================================================
  // RESTAURANT-SPECIFIC FOOD ITEMS
  // Every restaurant now has at least 5 matching food items.
  // ==========================================================================

  MilestoneApp6Food(
    id: 'the-italian-bistro-pepperoni-pizza',
    name: 'Pepperoni Pizza',
    category: 'Pizza',
    restaurant: 'The Italian Bistro',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
    price: 5.49,
    description: 'Freshly prepared pepperoni pizza with quality ingredients and a flavorful house-style finish.',
    isAvailable: false,
  ),

  MilestoneApp6Food(
    id: 'the-italian-bistro-creamy-alfredo-pasta',
    name: 'Creamy Alfredo Pasta',
    category: 'Pasta',
    restaurant: 'The Italian Bistro',
    image: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=900',
    price: 6.39,
    description: 'Freshly prepared creamy alfredo pasta with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'the-italian-bistro-garlic-bread',
    name: 'Garlic Bread',
    category: 'Sandwich',
    restaurant: 'The Italian Bistro',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 7.29,
    description: 'Freshly prepared garlic bread with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'the-italian-bistro-veggie-supreme-pizza',
    name: 'Veggie Supreme Pizza',
    category: 'Pizza',
    restaurant: 'The Italian Bistro',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
    price: 8.19,
    description: 'Freshly prepared veggie supreme pizza with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'sushi-world-california-roll',
    name: 'California Roll',
    category: 'Sushi',
    restaurant: 'Sushi World',
    image: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=900',
    price: 9.09,
    description: 'Freshly prepared california roll with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'sushi-world-tuna-nigiri',
    name: 'Tuna Nigiri',
    category: 'Sushi',
    restaurant: 'Sushi World',
    image: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=900',
    price: 9.99,
    description: 'Freshly prepared tuna nigiri with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'sushi-world-japanese-ramen',
    name: 'Japanese Ramen',
    category: 'Asian',
    restaurant: 'Sushi World',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 10.89,
    description: 'Freshly prepared japanese ramen with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'burger-hub-crispy-chicken-burger',
    name: 'Crispy Chicken Burger',
    category: 'Burger',
    restaurant: 'Burger Hub',
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=900',
    price: 5.49,
    description: 'Freshly prepared crispy chicken burger with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'burger-hub-veggie-burger',
    name: 'Veggie Burger',
    category: 'Burger',
    restaurant: 'Burger Hub',
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=900',
    price: 6.39,
    description: 'Freshly prepared veggie burger with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'burger-hub-spicy-bbq-burger',
    name: 'Spicy BBQ Burger',
    category: 'Burger',
    restaurant: 'Burger Hub',
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=900',
    price: 7.29,
    description: 'Freshly prepared spicy bbq burger with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'green-bowl-avocado-salad',
    name: 'Avocado Salad',
    category: 'Salad',
    restaurant: 'Green Bowl',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 8.19,
    description: 'Freshly prepared avocado salad with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'green-bowl-mediterranean-bowl',
    name: 'Mediterranean Bowl',
    category: 'Salad',
    restaurant: 'Green Bowl',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 9.09,
    description: 'Freshly prepared mediterranean bowl with quality ingredients and a flavorful house-style finish.',
    isAvailable: false,
  ),

  MilestoneApp6Food(
    id: 'green-bowl-green-veggie-bowl',
    name: 'Green Veggie Bowl',
    category: 'Salad',
    restaurant: 'Green Bowl',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 9.99,
    description: 'Freshly prepared green veggie bowl with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'green-bowl-quinoa-salad',
    name: 'Quinoa Salad',
    category: 'Salad',
    restaurant: 'Green Bowl',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 10.89,
    description: 'Freshly prepared quinoa salad with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'green-bowl-fresh-fruit-bowl',
    name: 'Fresh Fruit Bowl',
    category: 'Salad',
    restaurant: 'Green Bowl',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 5.49,
    description: 'Freshly prepared fresh fruit bowl with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'pasta-corner-spaghetti-aglio-e-olio',
    name: 'Spaghetti Aglio e Olio',
    category: 'Pasta',
    restaurant: 'Pasta Corner',
    image: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=900',
    price: 6.39,
    description: 'Freshly prepared spaghetti aglio e olio with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'pasta-corner-pesto-pasta',
    name: 'Pesto Pasta',
    category: 'Pasta',
    restaurant: 'Pasta Corner',
    image: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=900',
    price: 7.29,
    description: 'Freshly prepared pesto pasta with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'pasta-corner-cheesy-baked-pasta',
    name: 'Cheesy Baked Pasta',
    category: 'Pasta',
    restaurant: 'Pasta Corner',
    image: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=900',
    price: 8.19,
    description: 'Freshly prepared cheesy baked pasta with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'fresh-bites-paneer-sandwich',
    name: 'Paneer Sandwich',
    category: 'Sandwich',
    restaurant: 'Fresh Bites',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 9.09,
    description: 'Freshly prepared paneer sandwich with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'fresh-bites-cheese-corn-sandwich',
    name: 'Cheese Corn Sandwich',
    category: 'Sandwich',
    restaurant: 'Fresh Bites',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 9.99,
    description: 'Freshly prepared cheese corn sandwich with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'fresh-bites-mexican-veg-wrap',
    name: 'Mexican Veg Wrap',
    category: 'Sandwich',
    restaurant: 'Fresh Bites',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 10.89,
    description: 'Freshly prepared mexican veg wrap with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'morning-cafe-french-toast',
    name: 'French Toast',
    category: 'Breakfast',
    restaurant: 'Morning Cafe',
    image: 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=900',
    price: 5.49,
    description: 'Freshly prepared french toast with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'morning-cafe-masala-omelette',
    name: 'Masala Omelette',
    category: 'Breakfast',
    restaurant: 'Morning Cafe',
    image: 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=900',
    price: 6.39,
    description: 'Freshly prepared masala omelette with quality ingredients and a flavorful house-style finish.',
    isAvailable: false,
  ),

  MilestoneApp6Food(
    id: 'morning-cafe-breakfast-sandwich',
    name: 'Breakfast Sandwich',
    category: 'Sandwich',
    restaurant: 'Morning Cafe',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 7.29,
    description: 'Freshly prepared breakfast sandwich with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'asian-kitchen-schezwan-rice',
    name: 'Schezwan Rice',
    category: 'Asian',
    restaurant: 'Asian Kitchen',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 8.19,
    description: 'Freshly prepared schezwan rice with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'asian-kitchen-manchurian-noodles',
    name: 'Manchurian Noodles',
    category: 'Asian',
    restaurant: 'Asian Kitchen',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.09,
    description: 'Freshly prepared manchurian noodles with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'asian-kitchen-thai-curry',
    name: 'Thai Curry',
    category: 'Asian',
    restaurant: 'Asian Kitchen',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.99,
    description: 'Freshly prepared thai curry with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'spice-garden-paneer-tikka',
    name: 'Paneer Tikka',
    category: 'Asian',
    restaurant: 'Spice Garden',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 10.89,
    description: 'Freshly prepared paneer tikka with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'spice-garden-butter-chicken',
    name: 'Butter Chicken',
    category: 'Asian',
    restaurant: 'Spice Garden',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 5.49,
    description: 'Freshly prepared butter chicken with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'spice-garden-dal-tadka',
    name: 'Dal Tadka',
    category: 'Asian',
    restaurant: 'Spice Garden',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 6.39,
    description: 'Freshly prepared dal tadka with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'spice-garden-veg-biryani',
    name: 'Veg Biryani',
    category: 'Asian',
    restaurant: 'Spice Garden',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 7.29,
    description: 'Freshly prepared veg biryani with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'spice-garden-garlic-naan',
    name: 'Garlic Naan',
    category: 'Sandwich',
    restaurant: 'Spice Garden',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 8.19,
    description: 'Freshly prepared garlic naan with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'taco-fiesta-classic-veg-tacos',
    name: 'Classic Veg Tacos',
    category: 'Tacos',
    restaurant: 'Taco Fiesta',
    image: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=900',
    price: 9.09,
    description: 'Freshly prepared classic veg tacos with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'taco-fiesta-chicken-tacos',
    name: 'Chicken Tacos',
    category: 'Tacos',
    restaurant: 'Taco Fiesta',
    image: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=900',
    price: 9.99,
    description: 'Freshly prepared chicken tacos with quality ingredients and a flavorful house-style finish.',
    isAvailable: false,
  ),

  MilestoneApp6Food(
    id: 'taco-fiesta-cheese-tacos',
    name: 'Cheese Tacos',
    category: 'Tacos',
    restaurant: 'Taco Fiesta',
    image: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=900',
    price: 10.89,
    description: 'Freshly prepared cheese tacos with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'taco-fiesta-mexican-burrito',
    name: 'Mexican Burrito',
    category: 'Tacos',
    restaurant: 'Taco Fiesta',
    image: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=900',
    price: 5.49,
    description: 'Freshly prepared mexican burrito with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'taco-fiesta-nachos-supreme',
    name: 'Nachos Supreme',
    category: 'Tacos',
    restaurant: 'Taco Fiesta',
    image: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=900',
    price: 6.39,
    description: 'Freshly prepared nachos supreme with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'sweet-cravings-chocolate-cake',
    name: 'Chocolate Cake',
    category: 'Dessert',
    restaurant: 'Sweet Cravings',
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
    price: 7.29,
    description: 'Freshly prepared chocolate cake with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'sweet-cravings-red-velvet-cake',
    name: 'Red Velvet Cake',
    category: 'Dessert',
    restaurant: 'Sweet Cravings',
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
    price: 8.19,
    description: 'Freshly prepared red velvet cake with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'sweet-cravings-brownie',
    name: 'Brownie',
    category: 'Dessert',
    restaurant: 'Sweet Cravings',
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
    price: 9.09,
    description: 'Freshly prepared brownie with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'sweet-cravings-cheesecake',
    name: 'Cheesecake',
    category: 'Dessert',
    restaurant: 'Sweet Cravings',
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
    price: 9.99,
    description: 'Freshly prepared cheesecake with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'sweet-cravings-chocolate-cupcake',
    name: 'Chocolate Cupcake',
    category: 'Dessert',
    restaurant: 'Sweet Cravings',
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
    price: 10.89,
    description: 'Freshly prepared chocolate cupcake with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'royal-thali-gujarati-thali',
    name: 'Gujarati Thali',
    category: 'Asian',
    restaurant: 'Royal Thali',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 5.49,
    description: 'Freshly prepared gujarati thali with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'royal-thali-punjabi-thali',
    name: 'Punjabi Thali',
    category: 'Asian',
    restaurant: 'Royal Thali',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 6.39,
    description: 'Freshly prepared punjabi thali with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'royal-thali-special-veg-thali',
    name: 'Special Veg Thali',
    category: 'Asian',
    restaurant: 'Royal Thali',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 7.29,
    description: 'Freshly prepared special veg thali with quality ingredients and a flavorful house-style finish.',
    isAvailable: false,
  ),

  MilestoneApp6Food(
    id: 'royal-thali-dal-baati',
    name: 'Dal Baati',
    category: 'Asian',
    restaurant: 'Royal Thali',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 8.19,
    description: 'Freshly prepared dal baati with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'royal-thali-paneer-masala',
    name: 'Paneer Masala',
    category: 'Asian',
    restaurant: 'Royal Thali',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.09,
    description: 'Freshly prepared paneer masala with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'wok-express-hakka-noodles',
    name: 'Hakka Noodles',
    category: 'Asian',
    restaurant: 'Wok Express',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.99,
    description: 'Freshly prepared hakka noodles with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'wok-express-schezwan-fried-rice',
    name: 'Schezwan Fried Rice',
    category: 'Asian',
    restaurant: 'Wok Express',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 10.89,
    description: 'Freshly prepared schezwan fried rice with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'wok-express-manchurian',
    name: 'Manchurian',
    category: 'Asian',
    restaurant: 'Wok Express',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 5.49,
    description: 'Freshly prepared manchurian with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'wok-express-chilli-paneer',
    name: 'Chilli Paneer',
    category: 'Asian',
    restaurant: 'Wok Express',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 6.39,
    description: 'Freshly prepared chilli paneer with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'wok-express-spring-rolls',
    name: 'Spring Rolls',
    category: 'Asian',
    restaurant: 'Wok Express',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 7.29,
    description: 'Freshly prepared spring rolls with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'cafe-mocha-cappuccino',
    name: 'Cappuccino',
    category: 'Drinks',
    restaurant: 'Cafe Mocha',
    image: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=900',
    price: 8.19,
    description: 'Freshly prepared cappuccino with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'cafe-mocha-cafe-latte',
    name: 'Cafe Latte',
    category: 'Drinks',
    restaurant: 'Cafe Mocha',
    image: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=900',
    price: 9.09,
    description: 'Freshly prepared cafe latte with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'cafe-mocha-chocolate-muffin',
    name: 'Chocolate Muffin',
    category: 'Dessert',
    restaurant: 'Cafe Mocha',
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
    price: 9.99,
    description: 'Freshly prepared chocolate muffin with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'cafe-mocha-chocolate-brownie',
    name: 'Chocolate Brownie',
    category: 'Dessert',
    restaurant: 'Cafe Mocha',
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
    price: 10.89,
    description: 'Freshly prepared chocolate brownie with quality ingredients and a flavorful house-style finish.',
    isAvailable: false,
  ),

  MilestoneApp6Food(
    id: 'cafe-mocha-cold-coffee',
    name: 'Cold Coffee',
    category: 'Drinks',
    restaurant: 'Cafe Mocha',
    image: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=900',
    price: 5.49,
    description: 'Freshly prepared cold coffee with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'dosa-house-masala-dosa',
    name: 'Masala Dosa',
    category: 'Breakfast',
    restaurant: 'Dosa House',
    image: 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=900',
    price: 6.39,
    description: 'Freshly prepared masala dosa with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'dosa-house-plain-dosa',
    name: 'Plain Dosa',
    category: 'Breakfast',
    restaurant: 'Dosa House',
    image: 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=900',
    price: 7.29,
    description: 'Freshly prepared plain dosa with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'dosa-house-cheese-dosa',
    name: 'Cheese Dosa',
    category: 'Breakfast',
    restaurant: 'Dosa House',
    image: 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=900',
    price: 8.19,
    description: 'Freshly prepared cheese dosa with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'dosa-house-idli-sambar',
    name: 'Idli Sambar',
    category: 'Breakfast',
    restaurant: 'Dosa House',
    image: 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=900',
    price: 9.09,
    description: 'Freshly prepared idli sambar with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'dosa-house-mysore-masala-dosa',
    name: 'Mysore Masala Dosa',
    category: 'Breakfast',
    restaurant: 'Dosa House',
    image: 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=900',
    price: 9.99,
    description: 'Freshly prepared mysore masala dosa with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'the-bbq-station-bbq-paneer',
    name: 'BBQ Paneer',
    category: 'Asian',
    restaurant: 'The BBQ Station',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 10.89,
    description: 'Freshly prepared bbq paneer with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'the-bbq-station-bbq-chicken',
    name: 'BBQ Chicken',
    category: 'Asian',
    restaurant: 'The BBQ Station',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 5.49,
    description: 'Freshly prepared bbq chicken with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'the-bbq-station-chicken-tikka',
    name: 'Chicken Tikka',
    category: 'Asian',
    restaurant: 'The BBQ Station',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 6.39,
    description: 'Freshly prepared chicken tikka with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'the-bbq-station-seekh-kebab',
    name: 'Seekh Kebab',
    category: 'Asian',
    restaurant: 'The BBQ Station',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 7.29,
    description: 'Freshly prepared seekh kebab with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'the-bbq-station-grilled-vegetables',
    name: 'Grilled Vegetables',
    category: 'Salad',
    restaurant: 'The BBQ Station',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 8.19,
    description: 'Freshly prepared grilled vegetables with quality ingredients and a flavorful house-style finish.',
    isAvailable: false,
  ),

  MilestoneApp6Food(
    id: 'wrap-roll-paneer-wrap',
    name: 'Paneer Wrap',
    category: 'Sandwich',
    restaurant: 'Wrap & Roll',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 9.09,
    description: 'Freshly prepared paneer wrap with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'wrap-roll-chicken-wrap',
    name: 'Chicken Wrap',
    category: 'Sandwich',
    restaurant: 'Wrap & Roll',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 9.99,
    description: 'Freshly prepared chicken wrap with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'wrap-roll-veggie-roll',
    name: 'Veggie Roll',
    category: 'Sandwich',
    restaurant: 'Wrap & Roll',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 10.89,
    description: 'Freshly prepared veggie roll with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'wrap-roll-cheese-roll',
    name: 'Cheese Roll',
    category: 'Sandwich',
    restaurant: 'Wrap & Roll',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 5.49,
    description: 'Freshly prepared cheese roll with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'wrap-roll-spicy-mexican-wrap',
    name: 'Spicy Mexican Wrap',
    category: 'Sandwich',
    restaurant: 'Wrap & Roll',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 6.39,
    description: 'Freshly prepared spicy mexican wrap with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'biryani-house-chicken-biryani',
    name: 'Chicken Biryani',
    category: 'Asian',
    restaurant: 'Biryani House',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 7.29,
    description: 'Freshly prepared chicken biryani with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'biryani-house-veg-biryani',
    name: 'Veg Biryani',
    category: 'Asian',
    restaurant: 'Biryani House',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 8.19,
    description: 'Freshly prepared veg biryani with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'biryani-house-mutton-biryani',
    name: 'Mutton Biryani',
    category: 'Asian',
    restaurant: 'Biryani House',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.09,
    description: 'Freshly prepared mutton biryani with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'biryani-house-paneer-biryani',
    name: 'Paneer Biryani',
    category: 'Asian',
    restaurant: 'Biryani House',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.99,
    description: 'Freshly prepared paneer biryani with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'biryani-house-hyderabadi-biryani',
    name: 'Hyderabadi Biryani',
    category: 'Asian',
    restaurant: 'Biryani House',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 10.89,
    description: 'Freshly prepared hyderabadi biryani with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'the-healthy-kitchen-quinoa-bowl',
    name: 'Quinoa Bowl',
    category: 'Salad',
    restaurant: 'The Healthy Kitchen',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 5.49,
    description: 'Freshly prepared quinoa bowl with quality ingredients and a flavorful house-style finish.',
    isAvailable: false,
  ),

  MilestoneApp6Food(
    id: 'the-healthy-kitchen-protein-salad',
    name: 'Protein Salad',
    category: 'Salad',
    restaurant: 'The Healthy Kitchen',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 6.39,
    description: 'Freshly prepared protein salad with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'the-healthy-kitchen-avocado-bowl',
    name: 'Avocado Bowl',
    category: 'Salad',
    restaurant: 'The Healthy Kitchen',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 7.29,
    description: 'Freshly prepared avocado bowl with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'the-healthy-kitchen-grilled-veg-bowl',
    name: 'Grilled Veg Bowl',
    category: 'Salad',
    restaurant: 'The Healthy Kitchen',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 8.19,
    description: 'Freshly prepared grilled veg bowl with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'the-healthy-kitchen-chickpea-salad',
    name: 'Chickpea Salad',
    category: 'Salad',
    restaurant: 'The Healthy Kitchen',
    image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=900',
    price: 9.09,
    description: 'Freshly prepared chickpea salad with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'pizza-palace-margherita-pizza',
    name: 'Margherita Pizza',
    category: 'Pizza',
    restaurant: 'Pizza Palace',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
    price: 9.99,
    description: 'Freshly prepared margherita pizza with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'pizza-palace-farmhouse-pizza',
    name: 'Farmhouse Pizza',
    category: 'Pizza',
    restaurant: 'Pizza Palace',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
    price: 10.89,
    description: 'Freshly prepared farmhouse pizza with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'pizza-palace-paneer-tikka-pizza',
    name: 'Paneer Tikka Pizza',
    category: 'Pizza',
    restaurant: 'Pizza Palace',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
    price: 5.49,
    description: 'Freshly prepared paneer tikka pizza with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'pizza-palace-cheese-burst-pizza',
    name: 'Cheese Burst Pizza',
    category: 'Pizza',
    restaurant: 'Pizza Palace',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
    price: 6.39,
    description: 'Freshly prepared cheese burst pizza with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'pizza-palace-veggie-supreme-pizza',
    name: 'Veggie Supreme Pizza',
    category: 'Pizza',
    restaurant: 'Pizza Palace',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
    price: 7.29,
    description: 'Freshly prepared veggie supreme pizza with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'chai-snacks-masala-chai',
    name: 'Masala Chai',
    category: 'Drinks',
    restaurant: 'Chai & Snacks',
    image: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=900',
    price: 8.19,
    description: 'Freshly prepared masala chai with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'chai-snacks-cutting-chai',
    name: 'Cutting Chai',
    category: 'Drinks',
    restaurant: 'Chai & Snacks',
    image: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=900',
    price: 9.09,
    description: 'Freshly prepared cutting chai with quality ingredients and a flavorful house-style finish.',
    isAvailable: false,
  ),

  MilestoneApp6Food(
    id: 'chai-snacks-samosa',
    name: 'Samosa',
    category: 'Asian',
    restaurant: 'Chai & Snacks',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.99,
    description: 'Freshly prepared samosa with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'chai-snacks-kachori',
    name: 'Kachori',
    category: 'Asian',
    restaurant: 'Chai & Snacks',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 10.89,
    description: 'Freshly prepared kachori with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'chai-snacks-paneer-pakoda',
    name: 'Paneer Pakoda',
    category: 'Asian',
    restaurant: 'Chai & Snacks',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 5.49,
    description: 'Freshly prepared paneer pakoda with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'street-food-co-pav-bhaji',
    name: 'Pav Bhaji',
    category: 'Asian',
    restaurant: 'Street Food Co.',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 6.39,
    description: 'Freshly prepared pav bhaji with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'street-food-co-vada-pav',
    name: 'Vada Pav',
    category: 'Asian',
    restaurant: 'Street Food Co.',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 7.29,
    description: 'Freshly prepared vada pav with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'street-food-co-dahi-puri',
    name: 'Dahi Puri',
    category: 'Asian',
    restaurant: 'Street Food Co.',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 8.19,
    description: 'Freshly prepared dahi puri with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'street-food-co-sev-puri',
    name: 'Sev Puri',
    category: 'Asian',
    restaurant: 'Street Food Co.',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.09,
    description: 'Freshly prepared sev puri with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'street-food-co-bhel-puri',
    name: 'Bhel Puri',
    category: 'Asian',
    restaurant: 'Street Food Co.',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.99,
    description: 'Freshly prepared bhel puri with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'urban-eats-veg-burger',
    name: 'Veg Burger',
    category: 'Burger',
    restaurant: 'Urban Eats',
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=900',
    price: 10.89,
    description: 'Freshly prepared veg burger with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'urban-eats-chicken-burger',
    name: 'Chicken Burger',
    category: 'Burger',
    restaurant: 'Urban Eats',
    image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=900',
    price: 5.49,
    description: 'Freshly prepared chicken burger with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'urban-eats-cheese-pizza',
    name: 'Cheese Pizza',
    category: 'Pizza',
    restaurant: 'Urban Eats',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
    price: 6.39,
    description: 'Freshly prepared cheese pizza with quality ingredients and a flavorful house-style finish.',
    isAvailable: false,
  ),

  MilestoneApp6Food(
    id: 'urban-eats-pasta-alfredo',
    name: 'Pasta Alfredo',
    category: 'Pasta',
    restaurant: 'Urban Eats',
    image: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=900',
    price: 7.29,
    description: 'Freshly prepared pasta alfredo with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'urban-eats-loaded-nachos',
    name: 'Loaded Nachos',
    category: 'Tacos',
    restaurant: 'Urban Eats',
    image: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=900',
    price: 8.19,
    description: 'Freshly prepared loaded nachos with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'maharaja-kitchen-butter-chicken',
    name: 'Butter Chicken',
    category: 'Asian',
    restaurant: 'Maharaja Kitchen',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.09,
    description: 'Freshly prepared butter chicken with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'maharaja-kitchen-paneer-butter-masala',
    name: 'Paneer Butter Masala',
    category: 'Asian',
    restaurant: 'Maharaja Kitchen',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.99,
    description: 'Freshly prepared paneer butter masala with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'maharaja-kitchen-chicken-tikka',
    name: 'Chicken Tikka',
    category: 'Asian',
    restaurant: 'Maharaja Kitchen',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 10.89,
    description: 'Freshly prepared chicken tikka with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'maharaja-kitchen-dal-makhani',
    name: 'Dal Makhani',
    category: 'Asian',
    restaurant: 'Maharaja Kitchen',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 5.49,
    description: 'Freshly prepared dal makhani with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'maharaja-kitchen-garlic-naan',
    name: 'Garlic Naan',
    category: 'Sandwich',
    restaurant: 'Maharaja Kitchen',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 6.39,
    description: 'Freshly prepared garlic naan with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'bombay-street-vada-pav',
    name: 'Vada Pav',
    category: 'Asian',
    restaurant: 'Bombay Street',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 7.29,
    description: 'Freshly prepared vada pav with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'bombay-street-pav-bhaji',
    name: 'Pav Bhaji',
    category: 'Asian',
    restaurant: 'Bombay Street',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 8.19,
    description: 'Freshly prepared pav bhaji with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'bombay-street-dabeli',
    name: 'Dabeli',
    category: 'Asian',
    restaurant: 'Bombay Street',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.09,
    description: 'Freshly prepared dabeli with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'bombay-street-bhel-puri',
    name: 'Bhel Puri',
    category: 'Asian',
    restaurant: 'Bombay Street',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.99,
    description: 'Freshly prepared bhel puri with quality ingredients and a flavorful house-style finish.',
    isAvailable: false,
  ),

  MilestoneApp6Food(
    id: 'bombay-street-samosa',
    name: 'Samosa',
    category: 'Asian',
    restaurant: 'Bombay Street',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 10.89,
    description: 'Freshly prepared samosa with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'cheese-crust-cheese-margherita',
    name: 'Cheese Margherita',
    category: 'Pizza',
    restaurant: 'Cheese & Crust',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
    price: 5.49,
    description: 'Freshly prepared cheese margherita with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'cheese-crust-four-cheese-pizza',
    name: 'Four Cheese Pizza',
    category: 'Pizza',
    restaurant: 'Cheese & Crust',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
    price: 6.39,
    description: 'Freshly prepared four cheese pizza with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'cheese-crust-paneer-pizza',
    name: 'Paneer Pizza',
    category: 'Pizza',
    restaurant: 'Cheese & Crust',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
    price: 7.29,
    description: 'Freshly prepared paneer pizza with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'cheese-crust-cheese-burst-pizza',
    name: 'Cheese Burst Pizza',
    category: 'Pizza',
    restaurant: 'Cheese & Crust',
    image: 'https://images.unsplash.com/photo-1579751626657-72bc17010498?w=900',
    price: 8.19,
    description: 'Freshly prepared cheese burst pizza with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'cheese-crust-garlic-cheese-bread',
    name: 'Garlic Cheese Bread',
    category: 'Sandwich',
    restaurant: 'Cheese & Crust',
    image: 'https://images.unsplash.com/photo-1539252554453-80ab65ce3586?w=900',
    price: 9.09,
    description: 'Freshly prepared garlic cheese bread with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'noodle-nation-hakka-noodles',
    name: 'Hakka Noodles',
    category: 'Asian',
    restaurant: 'Noodle Nation',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 9.99,
    description: 'Freshly prepared hakka noodles with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'noodle-nation-schezwan-noodles',
    name: 'Schezwan Noodles',
    category: 'Asian',
    restaurant: 'Noodle Nation',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 10.89,
    description: 'Freshly prepared schezwan noodles with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'noodle-nation-chow-mein',
    name: 'Chow Mein',
    category: 'Asian',
    restaurant: 'Noodle Nation',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 5.49,
    description: 'Freshly prepared chow mein with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'noodle-nation-veg-fried-rice',
    name: 'Veg Fried Rice',
    category: 'Asian',
    restaurant: 'Noodle Nation',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 6.39,
    description: 'Freshly prepared veg fried rice with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'noodle-nation-chilli-garlic-noodles',
    name: 'Chilli Garlic Noodles',
    category: 'Asian',
    restaurant: 'Noodle Nation',
    image: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=900',
    price: 7.29,
    description: 'Freshly prepared chilli garlic noodles with quality ingredients and a flavorful house-style finish.',
    isAvailable: false,
  ),

  MilestoneApp6Food(
    id: 'dessert-story-chocolate-ice-cream',
    name: 'Chocolate Ice Cream',
    category: 'Dessert',
    restaurant: 'Dessert Story',
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
    price: 8.19,
    description: 'Freshly prepared chocolate ice cream with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'dessert-story-brownie-sundae',
    name: 'Brownie Sundae',
    category: 'Dessert',
    restaurant: 'Dessert Story',
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
    price: 9.09,
    description: 'Freshly prepared brownie sundae with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'dessert-story-red-velvet-cake',
    name: 'Red Velvet Cake',
    category: 'Dessert',
    restaurant: 'Dessert Story',
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
    price: 9.99,
    description: 'Freshly prepared red velvet cake with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'dessert-story-chocolate-cake',
    name: 'Chocolate Cake',
    category: 'Dessert',
    restaurant: 'Dessert Story',
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
    price: 10.89,
    description: 'Freshly prepared chocolate cake with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

  MilestoneApp6Food(
    id: 'dessert-story-strawberry-cheesecake',
    name: 'Strawberry Cheesecake',
    category: 'Dessert',
    restaurant: 'Dessert Story',
    image: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=900',
    price: 5.49,
    description: 'Freshly prepared strawberry cheesecake with quality ingredients and a flavorful house-style finish.',
    isAvailable: true,
  ),

];

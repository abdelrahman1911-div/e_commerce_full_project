import 'package:e_commerce_full_project/features/home/product/product_model.dart';

class ProductData {
  static const List<Map<String, dynamic>> clothingColors = [
    {'name': 'Black', 'colorValue': 0xFF111111},
    {'name': 'White', 'colorValue': 0xFFFFFFFF},
    {'name': 'Blue', 'colorValue': 0xFF2563EB},
    {'name': 'Red', 'colorValue': 0xFFDC2626},
  ];

  static const List<Map<String, dynamic>> kidsColors = [
    {'name': 'Black', 'colorValue': 0xFF111111},
    {'name': 'White', 'colorValue': 0xFFFFFFFF},
    {'name': 'Blue', 'colorValue': 0xFF2563EB},
    {'name': 'Green', 'colorValue': 0xFF16A34A},
  ];

  static const List<Map<String, dynamic>> shoeColors = [
    {'name': 'Black', 'colorValue': 0xFF111111},
    {'name': 'White', 'colorValue': 0xFFFFFFFF},
    {'name': 'Grey', 'colorValue': 0xFF6B7280},
    {'name': 'Blue', 'colorValue': 0xFF2563EB},
  ];

  static const List<Map<String, dynamic>> wetsuitColors = [
    {'name': 'Black', 'colorValue': 0xFF111111},
    {'name': 'Blue', 'colorValue': 0xFF1D4ED8},
    {'name': 'Red', 'colorValue': 0xFFDC2626},
  ];

  static const List<Map<String, dynamic>> boardColors = [
    {'name': 'Black', 'colorValue': 0xFF111111},
    {'name': 'Blue', 'colorValue': 0xFF2563EB},
    {'name': 'White', 'colorValue': 0xFFFFFFFF},
  ];

  // =========================
  // Product Sizes
  // =========================

  static const List<Map<String, dynamic>> clothingSizes = [
    {'label': 'S', 'isAvailable': true},
    {'label': 'M', 'isAvailable': true},
    {'label': 'L', 'isAvailable': true},
    {'label': 'XL', 'isAvailable': false},
    {'label': '2XL', 'isAvailable': true},
  ];

  static const List<Map<String, dynamic>> kidsSizes = [
    {'label': 'XS', 'isAvailable': true},
    {'label': 'S', 'isAvailable': true},
    {'label': 'M', 'isAvailable': true},
    {'label': 'L', 'isAvailable': false},
  ];

  static const List<Map<String, dynamic>> shoeSizes = [
    {'label': '40', 'isAvailable': true},
    {'label': '41', 'isAvailable': false},
    {'label': '42', 'isAvailable': true},
    {'label': '43', 'isAvailable': true},
    {'label': '44', 'isAvailable': true},
  ];

  static const List<Map<String, dynamic>> kidsShoeSizes = [
    {'label': '32', 'isAvailable': true},
    {'label': '33', 'isAvailable': true},
    {'label': '34', 'isAvailable': true},
    {'label': '35', 'isAvailable': true},
    {'label': '36', 'isAvailable': false},
  ];

  static const List<Map<String, dynamic>> jeansSizes = [
    {'label': '30', 'isAvailable': true},
    {'label': '32', 'isAvailable': true},
    {'label': '34', 'isAvailable': true},
    {'label': '36', 'isAvailable': true},
    {'label': '38', 'isAvailable': false},
  ];

  static const List<Map<String, dynamic>> dressSizes = [
    {'label': 'XS', 'isAvailable': false},
    {'label': 'S', 'isAvailable': true},
    {'label': 'M', 'isAvailable': true},
    {'label': 'L', 'isAvailable': true},
    {'label': 'XL', 'isAvailable': true},
  ];

  static const List<Map<String, dynamic>> wetsuitSizes = [
    {'label': 'S', 'isAvailable': true},
    {'label': 'M', 'isAvailable': false},
    {'label': 'L', 'isAvailable': true},
    {'label': 'XL', 'isAvailable': true},
  ];

  static const List<Map<String, dynamic>> boardSizes = [
    {'label': '6\'0"', 'isAvailable': true},
    {'label': '7\'0"', 'isAvailable': true},
    {'label': '8\'0"', 'isAvailable': false},
  ];

  // =========================
  // Products
  // =========================

  final List<Map<String, dynamic>> _productsJson = [
    // 1
    {
      'id': 1,
      'image':
          'https://imgs.search.brave.com/QTwrcOxH5eaK8JA4oQrmQrV8YAOQMjJATd5O1z1QJSM/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pLmV0/c3lzdGF0aWMuY29t/LzE1MTk0MjUxL3Iv/aWwvMWI2Y2JkLzE3/NTE3Nzc1NDUvaWxf/Nzk0eE4uMTc1MTc3/NzU0NV9naHVvLmpw/Zw',
      'brand': 'Rip Curl',
      'rating': '4.9',
      'reviews': '(126)',
      'name': '90s Soccer Windbreaker',
      'currentPrice': '\$39.99',
      'oldPrice': '\$79.99',
      'discount': '-50%',
      'isFavorite': false,
      'category': 'men',
      'description':
          'Classic 90s inspired soccer windbreaker with a lightweight design, comfortable fit, and sporty look perfect for everyday wear.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 2
    {
      'id': 2,
      'image':
          'https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&w=600&q=80',
      'brand': 'Adidas',
      'rating': '4.7',
      'reviews': '(89)',
      'name': 'Vintage Track Jacket',
      'currentPrice': '\$55.00',
      'oldPrice': '\$75.00',
      'discount': '-26%',
      'isFavorite': false,
      'category': 'men',
      'description':
          'Vintage inspired Adidas track jacket made with a comfortable lightweight material and a classic sporty design.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 3
    {
      'id': 3,
      'image':
          'https://images.unsplash.com/photo-1516826957135-700dedea698c?auto=format&fit=crop&w=600&q=80',
      'brand': 'Nike',
      'rating': '4.8',
      'reviews': '(210)',
      'name': 'Retro Nylon Windbreaker',
      'currentPrice': '\$49.99',
      'oldPrice': '\$60.00',
      'discount': '-16%',
      'isFavorite': false,
      'category': 'men',
      'description':
          'Retro nylon windbreaker featuring a lightweight construction, sporty silhouette, and comfortable fit for casual outfits.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 4
    {
      'id': 4,
      'image':
          'https://images.unsplash.com/photo-1598032895397-b9472444bf93?auto=format&fit=crop&w=600&q=80',
      'brand': 'Puma',
      'rating': '4.6',
      'reviews': '(74)',
      'name': 'Classic Sport Hoodie',
      'currentPrice': '\$44.99',
      'oldPrice': '\$65.00',
      'discount': '-31%',
      'isFavorite': false,
      'category': 'kids',
      'description':
          'Comfortable classic sport hoodie designed for everyday use with a relaxed fit and soft fabric construction.',
      'colors': kidsColors,
      'sizes': kidsSizes,
    },

    // 5
    {
      'id': 5,
      'image':
          'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=600&q=80',
      'brand': 'Levis',
      'rating': '4.8',
      'reviews': '(154)',
      'name': 'Classic Denim Jacket',
      'currentPrice': '\$69.99',
      'oldPrice': '\$95.00',
      'discount': '-26%',
      'isFavorite': false,
      'category': 'women',
      'description':
          'Timeless classic denim jacket with a durable construction, comfortable fit, and versatile style for everyday outfits.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 6
    {
      'id': 6,
      'image':
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?auto=format&fit=crop&w=600&q=80',
      'brand': 'Zara',
      'rating': '4.5',
      'reviews': '(98)',
      'name': 'Oversized Casual Jacket',
      'currentPrice': '\$59.99',
      'oldPrice': '\$89.99',
      'discount': '-33%',
      'isFavorite': false,
      'category': 'women',
      'description':
          'Modern oversized casual jacket with a clean silhouette and comfortable design suitable for everyday streetwear.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 7
    {
      'id': 7,
      'image':
          'https://images.unsplash.com/photo-1576566588028-4147f3842f27?auto=format&fit=crop&w=600&q=80',
      'brand': 'H&M',
      'rating': '4.4',
      'reviews': '(67)',
      'name': 'Essential Cotton T-Shirt',
      'currentPrice': '\$19.99',
      'oldPrice': '\$29.99',
      'discount': '-33%',
      'isFavorite': false,
      'category': 'women',
      'description':
          'Essential cotton t-shirt with a soft fabric, regular fit, and minimal design that works perfectly with casual outfits.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 8
    {
      'id': 8,
      'image':
          'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?auto=format&fit=crop&w=600&q=80',
      'brand': 'Uniqlo',
      'rating': '4.7',
      'reviews': '(183)',
      'name': 'Premium Oversized Sweatshirt',
      'currentPrice': '\$34.99',
      'oldPrice': '\$49.99',
      'discount': '-30%',
      'isFavorite': false,
      'category': 'wetsuits',
      'description':
          'Premium oversized sweatshirt made from soft fabric with a relaxed fit, perfect for comfortable everyday styling.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 9
    {
      'id': 9,
      'image':
          'https://images.unsplash.com/photo-1548883354-94bcfe321cbb?auto=format&fit=crop&w=600&q=80',
      'brand': 'New Balance',
      'rating': '4.9',
      'reviews': '(245)',
      'name': 'Urban Casual Jacket',
      'currentPrice': '\$74.99',
      'oldPrice': '\$110.00',
      'discount': '-32%',
      'isFavorite': false,
      'category': 'boards',
      'description':
          'Urban casual jacket combining sporty details with a modern streetwear look and comfortable everyday construction.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 10
    {
      'id': 10,
      'image':
          'https://images.unsplash.com/photo-1611312449408-fcece27cdbb7?auto=format&fit=crop&w=600&q=80',
      'brand': 'Under Armour',
      'rating': '4.8',
      'reviews': '(137)',
      'name': 'Performance Training Jacket',
      'currentPrice': '\$64.99',
      'oldPrice': '\$89.99',
      'discount': '-28%',
      'isFavorite': false,
      'category': 'men',
      'description':
          'Lightweight performance training jacket designed for active lifestyles with a sporty fit and comfortable construction.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 11
    {
      'id': 11,
      'image':
          'https://images.unsplash.com/photo-1523398002811-999ca8dec234?auto=format&fit=crop&w=600&q=80',
      'brand': 'Rip Curl',
      'rating': '4.8',
      'reviews': '(112)',
      'name': 'Surf Graphic T-Shirt',
      'currentPrice': '\$29.99',
      'oldPrice': '\$39.99',
      'discount': '-25%',
      'isFavorite': false,
      'category': 'men',
      'description':
          'Comfortable surf inspired graphic t-shirt made from soft cotton for everyday casual wear.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 12
    {
      'id': 12,
      'image':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=600&q=80',
      'brand': 'Adidas',
      'rating': '4.7',
      'reviews': '(156)',
      'name': 'Adidas Sports T-Shirt',
      'currentPrice': '\$34.99',
      'oldPrice': '\$45.00',
      'discount': '-22%',
      'isFavorite': false,
      'category': 'men',
      'description':
          'Lightweight sports t-shirt designed for comfortable everyday training and casual activities.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 13
    {
      'id': 13,
      'image':
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=600&q=80',
      'brand': 'Adidas',
      'rating': '4.9',
      'reviews': '(203)',
      'name': 'Women Training Outfit',
      'currentPrice': '\$59.99',
      'oldPrice': '\$85.00',
      'discount': '-29%',
      'isFavorite': false,
      'category': 'women',
      'description':
          'Modern comfortable training outfit with a sporty design suitable for active everyday wear.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 14
    {
      'id': 14,
      'image':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=600&q=80',
      'brand': 'Nike',
      'rating': '4.9',
      'reviews': '(342)',
      'name': 'Nike Running Shoes',
      'currentPrice': '\$89.99',
      'oldPrice': '\$120.00',
      'discount': '-25%',
      'isFavorite': false,
      'category': 'shoes',
      'description':
          'Comfortable lightweight running shoes designed with responsive cushioning for everyday movement.',
      'colors': shoeColors,
      'sizes': shoeSizes,
    },

    // 15
    {
      'id': 15,
      'image':
          'https://static.nike.com/a/images/t_web_pw_592_v2/f_auto/u_126ab356-44d8-4a06-89b4-fcdcc8df0245,c_scale,fl_relative,w_1.0,h_1.0,fl_layer_apply/4e54bf7d-6785-4601-81b6-16f550c4759c/JORDAN+1+RETRO+HIGH+OG+%28TD%29.png',
      'brand': 'Nike',
      'rating': '4.8',
      'reviews': '(198)',
      'name': 'Kids Sport Sneakers',
      'currentPrice': '\$49.99',
      'oldPrice': '\$70.00',
      'discount': '-29%',
      'isFavorite': false,
      'category': 'kids',
      'description':
          'Comfortable sport sneakers designed for kids with a lightweight construction and flexible sole.',
      'colors': kidsColors,
      'sizes': kidsShoeSizes,
    },

    // 16
    {
      'id': 16,
      'image':
          'https://images.unsplash.com/photo-1608231387042-66d1773070a5?auto=format&fit=crop&w=600&q=80',
      'brand': 'Puma',
      'rating': '4.7',
      'reviews': '(144)',
      'name': 'Puma Classic Sneakers',
      'currentPrice': '\$69.99',
      'oldPrice': '\$95.00',
      'discount': '-26%',
      'isFavorite': false,
      'category': 'shoes',
      'description':
          'Classic comfortable sneakers featuring a clean sporty style for casual everyday outfits.',
      'colors': shoeColors,
      'sizes': shoeSizes,
    },

    // 17
    {
      'id': 17,
      'image':
          'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=600&q=80',
      'brand': 'Levis',
      'rating': '4.8',
      'reviews': '(167)',
      'name': 'Women Slim Fit Jeans',
      'currentPrice': '\$54.99',
      'oldPrice': '\$79.99',
      'discount': '-31%',
      'isFavorite': false,
      'category': 'women',
      'description':
          'Classic slim fit denim jeans with a timeless design suitable for everyday casual styling.',
      'colors': clothingColors,
      'sizes': jeansSizes,
    },

    // 18
    {
      'id': 18,
      'image':
          'https://images.unsplash.com/photo-1542272604-787c3835535d?auto=format&fit=crop&w=600&q=80',
      'brand': 'Levis',
      'rating': '4.7',
      'reviews': '(121)',
      'name': 'Classic Men Denim Jeans',
      'currentPrice': '\$59.99',
      'oldPrice': '\$85.00',
      'discount': '-29%',
      'isFavorite': false,
      'category': 'men',
      'description':
          'Durable classic denim jeans with a comfortable fit and timeless everyday design.',
      'colors': clothingColors,
      'sizes': jeansSizes,
    },

    // 19
    {
      'id': 19,
      'image':
          'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?auto=format&fit=crop&w=600&q=80',
      'brand': 'Zara',
      'rating': '4.6',
      'reviews': '(88)',
      'name': 'Elegant Women Blazer',
      'currentPrice': '\$79.99',
      'oldPrice': '\$110.00',
      'discount': '-27%',
      'isFavorite': false,
      'category': 'women',
      'description':
          'Modern elegant blazer featuring a clean silhouette suitable for both casual and formal outfits.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 20
    {
      'id': 20,
      'image':
          'https://imgs.search.brave.com/TDFLdql1_2ZV8gmr1VqtxJCYWvSFofjata7Rfilb-Vw/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pLmVi/YXlpbWcuY29tL2lt/YWdlcy9nL21wTUFB/ZVN3OWZKcWhtUXYv/cy1sNDAwLndlYnA',
      'brand': 'Zara',
      'rating': '4.5',
      'reviews': '(76)',
      'name': 'Men Casual Shirt',
      'currentPrice': '\$44.99',
      'oldPrice': '\$60.00',
      'discount': '-25%',
      'isFavorite': false,
      'category': 'men',
      'description':
          'Modern casual shirt with a comfortable fit and clean design for everyday styling.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 21
    {
      'id': 21,
      'image':
          'https://images.unsplash.com/photo-1503341504253-dff4815485f1?auto=format&fit=crop&w=600&q=80',
      'brand': 'H&M',
      'rating': '4.6',
      'reviews': '(103)',
      'name': 'Kids Casual Outfit',
      'currentPrice': '\$39.99',
      'oldPrice': '\$55.00',
      'discount': '-27%',
      'isFavorite': false,
      'category': 'kids',
      'description':
          'Comfortable and stylish casual outfit designed for active everyday use by kids.',
      'colors': kidsColors,
      'sizes': kidsSizes,
    },

    // 22
    {
      'id': 22,
      'image':
          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=600&q=80',
      'brand': 'H&M',
      'rating': '4.5',
      'reviews': '(92)',
      'name': 'Women Summer Dress',
      'currentPrice': '\$49.99',
      'oldPrice': '\$70.00',
      'discount': '-29%',
      'isFavorite': false,
      'category': 'women',
      'description':
          'Lightweight comfortable summer dress featuring a modern casual design.',
      'colors': clothingColors,
      'sizes': dressSizes,
    },

    // 23
    {
      'id': 23,
      'image':
          'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?auto=format&fit=crop&w=600&q=80',
      'brand': 'Uniqlo',
      'rating': '4.8',
      'reviews': '(231)',
      'name': 'Minimal Cotton Hoodie',
      'currentPrice': '\$44.99',
      'oldPrice': '\$60.00',
      'discount': '-25%',
      'isFavorite': false,
      'category': 'men',
      'description':
          'Minimal comfortable cotton hoodie with a relaxed fit for everyday casual wear.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 24
    {
      'id': 24,
      'image':
          'https://images.unsplash.com/photo-1578681994506-b8f463449011?auto=format&fit=crop&w=600&q=80',
      'brand': 'Uniqlo',
      'rating': '4.7',
      'reviews': '(178)',
      'name': 'Women Basic Sweatshirt',
      'currentPrice': '\$39.99',
      'oldPrice': '\$55.00',
      'discount': '-27%',
      'isFavorite': false,
      'category': 'women',
      'description':
          'Soft comfortable basic sweatshirt with a clean minimal style.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 25
    {
      'id': 25,
      'image':
          'https://images.unsplash.com/photo-1605348532760-6753d2c43329?auto=format&fit=crop&w=600&q=80',
      'brand': 'New Balance',
      'rating': '4.9',
      'reviews': '(289)',
      'name': 'New Balance Lifestyle Shoes',
      'currentPrice': '\$99.99',
      'oldPrice': '\$140.00',
      'discount': '-29%',
      'isFavorite': false,
      'category': 'shoes',
      'description':
          'Premium lifestyle shoes combining everyday comfort with a modern sporty design.',
      'colors': shoeColors,
      'sizes': shoeSizes,
    },

    // 26
    {
      'id': 26,
      'image':
          'https://imgs.search.brave.com/Sx0dVnjdGo6sVfjp3ckPkfpy2blZ6uyr9OohpYXkbvw/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jZG4u/bWVkaWEuYW1wbGll/bmNlLm5ldC9pL3Nj/dmwvMTUxOTAyXzM0/MjQzNl8xP2ZtdD1h/dXRvJnc9NjQw',
      'brand': 'New Balance',
      'rating': '4.8',
      'reviews': '(164)',
      'name': 'Kids Running Shoes',
      'currentPrice': '\$54.99',
      'oldPrice': '\$75.00',
      'discount': '-27%',
      'isFavorite': false,
      'category': 'kids',
      'description':
          'Lightweight and comfortable running shoes designed for active kids.',
      'colors': kidsColors,
      'sizes': kidsShoeSizes,
    },

    // 27
    {
      'id': 27,
      'image':
          'https://imgs.search.brave.com/A_1y5qdIrrn7ukDwAXzfwm7-mi3_NJrPJZSIG4CRWoo/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jZG4u/ZHNtY2RuLmNvbS9t/bnJlc2l6ZS80MDAv/LS90eTE4MDIvcHJv/ZC9RQ19QUkVQLzIw/MjUxMjE1LzA1L2Qw/ZjBjYTM0LWQzY2It/M2Q4MS1hNDE0LTZj/NGQxZTZlYTBmYi8x/X29yZ196b29tLmpw/Zw',
      'brand': 'Under Armour',
      'rating': '4.9',
      'reviews': '(276)',
      'name': 'Training Sports T-Shirt',
      'currentPrice': '\$34.99',
      'oldPrice': '\$50.00',
      'discount': '-30%',
      'isFavorite': false,
      'category': 'men',
      'description':
          'Performance sports t-shirt designed with lightweight breathable fabric for training.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 28
    {
      'id': 28,
      'image':
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=600&q=80',
      'brand': 'Under Armour',
      'rating': '4.8',
      'reviews': '(195)',
      'name': 'Women Training Set',
      'currentPrice': '\$79.99',
      'oldPrice': '\$110.00',
      'discount': '-27%',
      'isFavorite': false,
      'category': 'women',
      'description':
          'Comfortable high performance training set designed for active workouts.',
      'colors': clothingColors,
      'sizes': clothingSizes,
    },

    // 29
    {
      'id': 29,
      'image':
          'https://images.unsplash.com/photo-1502680390469-be75c86b636f?auto=format&fit=crop&w=600&q=80',
      'brand': 'Rip Curl',
      'rating': '4.9',
      'reviews': '(142)',
      'name': 'Surf Wetsuit',
      'currentPrice': '\$129.99',
      'oldPrice': '\$180.00',
      'discount': '-28%',
      'isFavorite': false,
      'category': 'wetsuits',
      'description':
          'Flexible surf wetsuit designed to provide comfort and performance during water activities.',
      'colors': wetsuitColors,
      'sizes': wetsuitSizes,
    },

    // 30
    {
      'id': 30,
      'image':
          'https://images.unsplash.com/photo-1502680390469-be75c86b636f?auto=format&fit=crop&w=600&q=80',
      'brand': 'Rip Curl',
      'rating': '4.7',
      'reviews': '(97)',
      'name': 'Professional Surf Board',
      'currentPrice': '\$299.99',
      'oldPrice': '\$399.99',
      'discount': '-25%',
      'isFavorite': false,
      'category': 'boards',
      'description':
          'Professional surf board designed for smooth performance and reliable control in the water.',
      'colors': boardColors,
      'sizes': boardSizes,
    },
  ];

  List<ProductModel> get productsList {
    return _productsJson.map((json) => ProductModel.fromJson(json)).toList();
  }
}

import 'package:e_commerce_full_project/features/brandscreen/brand/brand_model.dart';

class BrandData {
  final List<Map<String, dynamic>> _brandsJson = [
    {
      'id': 1,
      'name': 'Rip Curl',
      'image':
          'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=500&q=80',
    },
    {
      'id': 2,
      'name': 'Adidas',
      'image': 'https://imgs.search.brave.com/VvzyY2uWse12IesoVlfAI9PX3NMjtG7u7cLHue3S80Q/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJjYXZlLmNv/bS93cC93cDI1ODgw/NTQuanBn',
    },
    {
      'id': 3,
      'name': 'Nike',
      'image': 'https://imgs.search.brave.com/aICJUq2u1a468Wg2PrqF7MtjaOC_4zkRGx15LXXeP6Q/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5nZXR0eWltYWdl/cy5jb20vaWQvMjIx/NTA4MjcyOS9waG90/by9wcm9qZWN0aW5n/LXNpZ24td2l0aC1u/aWtlLXN3b29zaC1s/b2dvLW91dHNpZGUt/cmV0YWlsLXN0b3Jl/LWFnYWluc3QtYmx1/ZS1za3ktYW5kLWhp/Z2gtcmlzZS5qcGc_/cz02MTJ4NjEyJnc9/MCZrPTIwJmM9dW8w/UTZJODF4OHpnV1hL/cEdrZUFVaGpjZFhT/WnBfX0N6RVJIVjV1/OGVsQT0',
    },
    {
      'id': 4,
      'name': 'Puma',
      'image': 'https://imgs.search.brave.com/n2o-q5lXtcmhjzw6-1z4_OB6ABm-uGaXb3m9_vITGqA/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9sb2dv/cy13b3JsZC5uZXQv/d3AtY29udGVudC91/cGxvYWRzLzIwMjAv/MDQvUHVtYS1TeW1i/b2wtNzAweDM5NC5q/cGc',
    },
    {
      'id': 5,
      'name': "Levis",
      'image': 'https://imgs.search.brave.com/PwM8s4KiYx1p50rnO-VNfu9YFmC3d-h36q-ftN6Q38I/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93d3cu/bG9nb2Rlc2lnbi5v/cmcvaW1nL2EwOGMx/NTJlMGY3YWRkZWEu/cG5n',
    },
    {
      'id': 6,
      'name': 'Zara',
      'image': 'https://imgs.search.brave.com/vCA1DdZQri-zdyt-9UDJ5oSyC19W1NCY5v8T4zVXn3o/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pbnN0/YW50bG9nb2Rlc2ln/bi5jb20vYmxvZy93/cC1jb250ZW50L3Vw/bG9hZHMvMjAyMi8w/OC8xOTc1LXRvLTIw/MDgtWmFyYS1sb2dv/LWRlc2lnbi0xMDI0/eDUzOC5qcGc',
    },
    {
      'id': 7,
      'name': 'H&M',
      'image': 'https://imgs.search.brave.com/G3AOLljJUVq0aq70f6RRT6z8lo2q4tEedXZI5awB7eE/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9sb2dv/cy13b3JsZC5uZXQv/d3AtY29udGVudC91/cGxvYWRzLzIwMjAv/MDQvSE0tTG9nby0x/OTY4LTE5OTktNzAw/eDM5NC5wbmc',
    },
    {
      'id': 8,
      'name': 'Uniqlo',
      'image': 'https://imgs.search.brave.com/EF4O6HVoZBVCQuoK1zqkm8FZglfH4iCDBBlwMqJprg0/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9sb2dv/ZGl4LmNvbS9sb2dv/LzIzNzA1MC5wbmc',
    },
    {
      'id': 9,
      'name': 'New Balance',
      'image': 'https://imgs.search.brave.com/7qnoZ39WCpvWNqflTfvWTtBtWYWB1KlSsllje-nR_OQ/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9sb2dv/ZG93bmxvYWQub3Jn/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDE3/LzA3L25ldy1iYWxh/bmNlLWxvZ28tOC5w/bmc',
    },
    {
      'id': 10,
      'name': 'Under Armour',
      'image': 'https://imgs.search.brave.com/Sxz2yxn8SkitJBZl361m0C6Iy3ARxP4YVxhf6e1D1ds/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jb21w/YW5pZXNsb2dvLmNv/bS9pbWcvb3JpZy9V/QV9CSUcuRC1iOTcy/MDg4MS5wbmc_dD0x/NzIwMjQ0NDk0',
    },
  ];

  List<BrandModel> get brandsList {
    return _brandsJson.map((json) => BrandModel.fromJson(json)).toList();
  }
}
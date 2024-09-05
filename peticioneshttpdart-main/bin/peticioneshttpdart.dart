
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post.dart';

class Geo {
  final String lat;
  final String lng;

  Geo({required this.lat, required this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      suite: json['suite'],
      city: json['city'],
      zipcode: json['zipcode'],
      geo: Geo.fromJson(json['geo']),
    );
  }
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      catchPhrase: json['catchPhrase'],
      bs: json['bs'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: Address.fromJson(json['address']),
      phone: json['phone'],
      website: json['website'],
      company: Company.fromJson(json['company']),
    );
  }
}

Future<List<User>> fetchUsers() async {
  var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Error al obtener los usuarios');
  }
}

List<User> filterUsersByUsernameLength(List<User> users, int length) {
  return users.where((user) => user.username.length > length).toList();
}

int countUsersWithBizDomain(List<User> users) {
  return users.where((user) => user.email.endsWith('.biz')).length;
}

void main() async {
  try {
    List<User> users = await fetchUsers();

    print('Usuarios con más de 6 caracteres en su username:');
    List<User> filteredUsers = filterUsersByUsernameLength(users, 6);
    filteredUsers.forEach((user) => print('${user.username} (${user.name})'));

    int bizDomainCount = countUsersWithBizDomain(users);
    print('\nCantidad de usuarios con dominio .biz: $bizDomainCount');
  } catch (e) {
    print(e);
  }
}

/*
void main() async {
  // URL de la API
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

  // Realizar la petición GET
  final response = await http.get(url);

  print(response);

  // Verificar si la petición fue exitosa
  if (response.statusCode == 200) {
    // Parsear la respuesta JSON a una lista
    List<dynamic> jsonData = json.decode(response.body);

    // Crear una lista de Post
    List<Post> posts = jsonData.map((json) => Post.fromJson(json)).toList();

    // Mostrar los datos
    posts.forEach((post) {
      print('User ID: ${post.userId}');
      print('ID: ${post.id}');
      print('Title: ${post.title}');
      print('Body: ${post.body}');
      print('---');
    });
  } else {
    // Manejo de errores
    print('Error al obtener los datos: ${response.statusCode}');
  }
}
*/

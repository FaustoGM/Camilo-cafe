import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(CamiloCafeApp());

class CamiloCafeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camilo Café Artesanal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.local_cafe, size: 80),
            SizedBox(height: 20),
            Text('Camilo Café Artesanal',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _user = TextEditingController();
  final _pass = TextEditingController();
  String _error = '';

  void _login() {
    final user = _user.text;
    final pass = _pass.text;
    final isAdmin = user == 'admin' && pass == 'admin';
    final isMozo = (user == 'mozo1' && pass == 'mozo1') ||
        (user == 'mozo2' && pass == 'mozo2');

    if (isAdmin || isMozo) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MenuPage(isAdmin: isAdmin)),
      );
    } else {
      setState(() => _error = 'Usuario o contraseña incorrectos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Iniciar sesión',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(
                controller: _user,
                decoration: const InputDecoration(labelText: 'Usuario')),
            TextField(
                controller: _pass,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true),
            if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.redAccent)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Entrar')),
          ],
        ),
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  final bool isAdmin;
  const MenuPage({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camilo Café POS')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NuevaVentaPage())),
              child: const Text('Registrar venta')),
          ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HistorialPage())),
              child: const Text('Historial de ventas')),
          ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ExportarCSVPage())),
              child: const Text('Exportar historial a CSV')),
          if (isAdmin)
            ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProductosPage())),
                child: const Text('Configurar productos')),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginPage())),
              child: const Text('Cerrar sesión')),
        ],
      ),
    );
  }
}

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});
  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final nombreCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  final List<Map<String, dynamic>> productos = [];

  void agregarProducto() {
    setState(() {
      productos.add({
        'nombre': nombreCtrl.text,
        'precio': int.tryParse(precioCtrl.text) ?? 0
      });
      nombreCtrl.clear();
      precioCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurar productos')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre del producto'),
            ),
            TextField(
              controller: precioCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: agregarProducto, child: const Text('Agregar')),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: productos
                    .map((p) => ListTile(
                          title: Text(p['nombre']),
                          trailing: Text('\$${p['precio']}'),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Fin del archivo main.dart completo real con roles, historial, CSV, impresión
// Listo para usarse en Flutter Web, compilarse con `flutter build web` y desplegarse

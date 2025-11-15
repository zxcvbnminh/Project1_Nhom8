// lib/main.dart
import 'package:flutter/material.dart';
import 'package:instagram_tut/services/api_client.dart';
import 'package:instagram_tut/ui/home_page/home_page.dart';
import 'package:instagram_tut/ui/auth_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  ApiClient().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo Flutter Web',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashOrLogin(),
    );
  }
}

/// Splash: kiểm tra token, nếu có -> vào TodosPage, nếu không -> LoginPage
class SplashOrLogin extends StatefulWidget {
  const SplashOrLogin({super.key});

  @override
  _SplashOrLoginState createState() => _SplashOrLoginState();
}

class _SplashOrLoginState extends State<SplashOrLogin> {
  bool checking = true;
  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final token = await ApiClient().getToken();
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    if (token != null) {
      final  prefs = await SharedPreferences.getInstance();
      final String name =prefs.getString('keyUserName') ?? '';
      final String key =prefs.getString('keyUserId') ?? '';
      prefs.getString('keyUserId') ?? '';
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage(username: name,userId: key,)));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AuthPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}



// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _userCtrl = TextEditingController();
//   final _passCtrl = TextEditingController();
//   bool _loading = false;
//   String? _error;
//
//   void _login() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });
//     final dto = UserDTO(username: _userCtrl.text.trim(), password: _passCtrl.text);
//     final res = await Api.login(dto);
//     setState(() => _loading = false);
//     if (res['ok'] == true) {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => TodosPage()));
//     } else {
//       setState(() {
//         _error = 'Login failed: ${res['message'] ?? res['status']}';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Center(
//         child: ConstrainedBox(
//           constraints: BoxConstraints(maxWidth: 480),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               TextField(controller: _userCtrl, decoration: InputDecoration(labelText: 'Username')),
//               SizedBox(height: 12),
//               TextField(controller: _passCtrl, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
//               SizedBox(height: 20),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: _loading ? null : _login,
//                   child: _loading ? CircularProgressIndicator(color: Colors.white) : Text('Login'),
//                 ),
//               ),
//               if (_error != null) ...[
//                 SizedBox(height: 12),
//                 Text(_error!, style: TextStyle(color: Colors.red)),
//               ],
//               SizedBox(height: 8),
//               Text('Nếu chưa có tài khoản, tạo bằng Swagger /auth/register'),
//             ]),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class TodosPage extends StatefulWidget {
//   @override
//   _TodosPageState createState() => _TodosPageState();
// }
//
// class _TodosPageState extends State<TodosPage> {
//   bool _loading = false;
//   List<TodoDTO> _todos = [];
//   String? _error;
//   final _titleCtrl = TextEditingController();
//   bool _creating = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }
//
//   void _load() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });
//     final res = await Api.getTodos();
//     setState(() {
//       _loading = false;
//     });
//     if (res['ok'] == true) {
//       setState(() {
//         _todos = List<TodoDTO>.from(res['todos'] as List<TodoDTO>);
//       });
//     } else {
//       setState(() {
//         _error = 'Error: ${res['message'] ?? res['status']}';
//       });
//       if (res['status'] == 401) {
//         // token expired or missing
//         await Api.removeToken();
//         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
//       }
//     }
//   }
//
//   void _create() async {
//     final title = _titleCtrl.text.trim();
//     if (title.isEmpty) return;
//     setState(() => _creating = true);
//     final res = await Api.createTodo(title, false);
//     setState(() => _creating = false);
//     if (res['ok'] == true) {
//       setState(() {
//         _todos.insert(0, res['todo'] as TodoDTO);
//         _titleCtrl.clear();
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Create failed: ${res['message']}')));
//       if (res['status'] == 401) {
//         await Api.removeToken();
//         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
//       }
//     }
//   }
//
//   void _logout() async {
//     await Api.removeToken();
//     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
//   }
//
//   Widget _buildList() {
//     if (_loading) return Center(child: CircularProgressIndicator());
//     if (_error != null) return Center(child: Text(_error!));
//     if (_todos.isEmpty) return Center(child: Text('No todos yet'));
//     return ListView.separated(
//       itemCount: _todos.length,
//       separatorBuilder: (_, __) => Divider(height: 1),
//       itemBuilder: (context, idx) {
//         final t = _todos[idx];
//         return ListTile(
//           title: Text(t.title),
//           subtitle: Text('Owner: ${t.ownerId ?? "unknown"}'),
//           trailing: Icon(t.completed ? Icons.check_circle : Icons.circle_outlined),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Todos'),
//         actions: [
//           IconButton(onPressed: _load, icon: Icon(Icons.refresh)),
//           IconButton(onPressed: _logout, icon: Icon(Icons.exit_to_app)),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(children: [
//               Expanded(
//                 child: TextField(controller: _titleCtrl, decoration: InputDecoration(labelText: 'New todo title')),
//               ),
//               SizedBox(width: 8),
//               ElevatedButton(
//                 onPressed: _creating ? null : _create,
//                 child: _creating ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text('Add'),
//               )
//             ]),
//           ),
//           Expanded(child: _buildList())
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _titleCtrl.dispose();
//     super.dispose();
//   }
// }
//
//

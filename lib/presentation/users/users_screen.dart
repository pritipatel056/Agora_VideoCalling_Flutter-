import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/user_remote_datasource.dart';
import '../../data/datasources/user_local_datasource.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/models/user_model.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late final UserRepository repo;
  List<UserModel> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final client = DioClient();
    final remote = UserRemoteDataSource(client);
    final box = Hive.box('users_cache');
    final local = UserLocalDataSource(box);
    repo = UserRepository(remote: remote, local: local);
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final users = await repo.getUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load users')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users'), actions: [
        IconButton(onPressed: () => Navigator.pushNamed(context, '/video'), icon: const Icon(Icons.video_call))
      ]),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, i) {
            final u = _users[i];
            return ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(u.avatar)),
              title: Text('${u.firstName} ${u.lastName}'),
              subtitle: Text(u.email),
            );
          },
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_atvisor/shared_module/views/search_mask.dart';
import 'package:travel_atvisor/user_module/models/user_suggestion.dart';
import 'package:travel_atvisor/user_module/pages/user_screen.dart';
import 'package:travel_atvisor/user_module/user.data_service.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({Key? key}) : super(key: key);

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  @override
  Widget build(BuildContext context) {
    return SearchMask<UserSuggestion, void>(
        searchAction: ((searchTerm, activeSuggestionFilter) {
          if (searchTerm.isEmpty) return Future.value([]);
          return context.read<UserDataService>().searchUsersAsync(searchTerm);
        }),
        resultBuilder: (context, result) {
          return ListTile(
            leading: ClipOval(
              child: Image(
                image: NetworkImage(result.photoUrl),
              ),
            ),
            title: Text(result.fullName),
            subtitle: Text(result.userName),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserScreen(
                  userId: result.userId,
                ),
              ),
            ),
          );
        },
        title: const Text("Suchen"));
  }
}

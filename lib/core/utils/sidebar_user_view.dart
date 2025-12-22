import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/core/enums/presence_state.dart';

class SidebarUserView {
  final String name;
  final String photoUrl;
  final PresenceState presence;

  const SidebarUserView({
    required this.name,
    required this.photoUrl,
    required this.presence,
  });
}

SidebarUserView buildSidebarUserView(Map<String, dynamic>? userData) {
  if (userData == null) {
    return const SidebarUserView(
      name: 'Ismeretlen',
      photoUrl: '',
      presence: PresenceState.offline,
    );
  }

  final name = (userData['name'] ?? 'Ismeretlen').toString();
  final photoUrl = (userData['photo_url'] ?? '').toString();

  final bool isOnline = userData['is_online'] == true;
  final Timestamp? lastSeen = userData['last_seen'] as Timestamp?;

  final PresenceState presence;

  if (isOnline) {
    presence = PresenceState.online;
  } else if (lastSeen != null &&
      lastSeen.toDate().isAfter(
        DateTime.now().subtract(const Duration(minutes: 30)),
      )) {
    presence = PresenceState.away;
  } else {
    presence = PresenceState.offline;
  }

  return SidebarUserView(name: name, photoUrl: photoUrl, presence: presence);
}

import 'package:alexandrio_app/Data/Credentials.dart';
import 'package:flutter/material.dart';
import 'package:dart_discord/Discord.dart' as discord;

// https://discord.com/api/webhooks/826812924940779591/5willre6V-3ts9bNfVNcKOMxwonP8T6WZUaO9xLwU_PZDcIaK91ZaImqXEWysY3x8lZr
class FeedbackPage extends StatefulWidget {
  final Credentials credentials;

  const FeedbackPage({
    Key key,
    @required this.credentials,
  }) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController feedbackTextController = TextEditingController();

  @override
  void dispose() {
    feedbackTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Send feedback'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            var webhook = discord.Webhook('https://discord.com/api/webhooks/826812924940779591/5willre6V-3ts9bNfVNcKOMxwonP8T6WZUaO9xLwU_PZDcIaK91ZaImqXEWysY3x8lZr');
            await webhook.send(
              discord.WebhookMessage(
                embeds: [
                  discord.Embed(
                    title: 'Feedback received from ${widget.credentials.login}',
                    description: feedbackTextController.text,
                    author: discord.EmbedAuthor(
                      name: widget.credentials.email,
                    ),
                  ),
                ],
              ),
            );
          },
          label: Text('Send feedback'),
          icon: Icon(Icons.send),
        ),
        body: ListView(
          padding: EdgeInsets.all(8.0),
          children: [
            TextField(
              controller: feedbackTextController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Feedback',
              ),
              maxLines: null,
            ),
          ],
        ),
      );
}

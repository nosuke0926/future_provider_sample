import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_provider_sample/provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postalCode = ref.watch(apiProvider);
    final familyPostalCode =
        ref.watch(apiFamilyProvider(ref.watch(postalCodeProvider)));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (text) => onPostalCodeChanges(ref, text),
            ),
            Text('without family'),
            Expanded(
              child: postalCode.when(
                data: (data) {
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: data.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.data[index].en.prefecture),
                            Text(data.data[index].en.address1),
                            Text(data.data[index].en.address2),
                            Text(data.data[index].en.address3),
                            Text(data.data[index].en.address4),
                          ],
                        ),
                      );
                    },
                  );
                },
                error: (error, stack) {
                  return Text(error.toString());
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Text('with family'),
            Expanded(
              child: familyPostalCode.when(
                data: (data) {
                  return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: data.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.data[index].en.prefecture),
                            Text(data.data[index].en.address1),
                            Text(data.data[index].en.address2),
                            Text(data.data[index].en.address3),
                            Text(data.data[index].en.address4),
                          ],
                        ),
                      );
                    },
                  );
                },
                error: (error, stack) {
                  return Text(error.toString());
                },
                loading: () {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onPostalCodeChanges(WidgetRef ref, String text) {
    if (text.length != 7) {
      return;
    }

    try {
      int.parse(text);
      ref.watch(postalCodeProvider.state).update((state) => text);
      print(text);
    } catch (e) {
      print(e);
    }
  }
}

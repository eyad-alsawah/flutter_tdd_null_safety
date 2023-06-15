import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:tdd/injection_container.dart';

import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider(
        // specifying the type is enough for the dependecy to be resolved
        create: (context) => serviceLocator<NumberTriviaBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 20),
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    print(state);
                    if (state is EmptyNumberTriviaState) {
                      return const MessageWidget(message: 'Start Searching');
                    }
                    if (state is ErrorNumberTriviaState) {
                      return MessageWidget(message: state.message);
                    }
                    if (state is LoadedNumberTriviaState) {
                      return TriviaDisplay(
                        numberTrivia: state.numberTriviaEntity,
                      );
                    }
                    if (state is LoadingNumberTriviaState) {
                      return const LoadingWidget();
                    }

                    return const TriviaDisplay(
                      numberTrivia:
                          NumberTriviaEntity(number: 1, text: "some text"),
                    );
                  },
                ),
                const SizedBox(height: 20),
                TriviaControl(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TriviaControl extends StatefulWidget {
  const TriviaControl({super.key});

  @override
  State<TriviaControl> createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  String inputString = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter a number",
          ),
          onChanged: (value) {
            inputString = value;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await dispatchConcrete();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.green,
                  ),
                ),
                child: const Text('Search'),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.green,
                  ),
                ),
                child: const Text('Get Random Trivia'),
              ),
            ),
          ],
        )
      ],
    );
  }

  Future<void> dispatchConcrete() async {
    context.read<NumberTriviaBloc>().add(
          GetTriviaForConcreteNumber(inputString),
        );
  }
}

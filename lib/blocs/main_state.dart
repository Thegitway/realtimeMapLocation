enum States { Loading, Init, posLoaded }

class MainState {
  States state;
  Map<dynamic, dynamic>? pos;
  MainState(this.state, {this.pos});

  factory MainState.loading() {
    return MainState(States.Loading);
  }
  factory MainState.initState() {
    return MainState(States.Init);
  }
  factory MainState.posLoaded(Map<dynamic, dynamic> poss) {
    return MainState(States.posLoaded, pos: poss);
  }
}

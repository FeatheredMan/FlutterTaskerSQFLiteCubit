abstract class DatabaseState<State> {}

class DatabaseInitialState extends DatabaseState {}

class DatabaseGetState extends DatabaseState {}

class DatabaseAddState extends DatabaseState {}

class DatabaseDeleteState extends DatabaseState {}

class DatabaseUpdateState extends DatabaseState {}

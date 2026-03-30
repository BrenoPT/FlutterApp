import 'package:flutter_test/flutter_test.dart';

abstract class Pessoa {
  late int _id;
  String nome;

  Pessoa(this.nome);

  int get id => _id;

  set id(int id) {
    if (id > 0) {
      _id = id;
    } else {
      throw ArgumentError('Identificador deve ser não negativo.');
    }
  }
}

mixin Ano {
  late int _ano;

  int get ano => _ano;

  set ano(int ano) {
    if (ano > 0) {
      _ano = ano;
    } else {
      throw ArgumentError('Ano deve ser não negativo.');
    }
  }
}

class Aluno extends Pessoa with Ano {
  Aluno(super.nome, int ano) {
    this.ano = ano;
  }
}

class Professor extends Pessoa {
  Professor(super.nome);
}

class Disciplina {
  String nome;
  Disciplina(this.nome);
}

class Turma with Ano {
  Disciplina disciplina;
  final List<Aluno> _alunos = [];
  String professor;

  Turma(this.disciplina, this.professor, int ano) {
    this.ano = ano;
  }

  void matricular(Aluno aluno) {
    if (aluno.ano != ano) {
      throw ArgumentError('Ano deve ser mesmo.');
    }

    _alunos.add(aluno);
  }
}

class Historico extends Turma {
  Map<Aluno, List<double>> notas = {};

  Historico(super.disciplina, super.professor, super.ano);

  @override
  void matricular(Aluno aluno) {
    super.matricular(aluno);
    notas[aluno] = [];
  }

  double media(Aluno aluno) {
    if (notas[aluno] == null || notas[aluno]!.isEmpty) {
      return 0.0;
    }
    double media = 0;
    for (double nota in notas[aluno]!) {
      media += nota;
    }
    media /= notas[aluno]!.length;
    return media;
  }

  bool isAprovado(Aluno aluno) {
    if (media(aluno) >= 6) {
      return true;
    } else {
      return false;
    }
  }
}

void main() {
  test('Testar matrícula de alunos', () {
    Disciplina disciplina1 = Disciplina('Flutter');
    Historico historico1 = Historico(disciplina1, 'Professor Fulano', 2023);
    // Cadastrar primeiro aluno sem erros
    Aluno aluno1 = Aluno('Maria', 2023);
    aluno1.id = 1;
    historico1.matricular(aluno1);
    expect(historico1.media(aluno1), 0.0);
    // Cadastrar segundo aluno com erros
    Aluno aluno2 = Aluno('Paula', 2022);
    expect(() => aluno2.id = 0, throwsArgumentError);
    expect(() => historico1.matricular(aluno2), throwsArgumentError);
    //checar se a lógica de media e aprovação funcionam
    historico1.notas[aluno1]?.addAll([10, 5, 6]);
    expect(historico1.media(aluno1), 7.0);
    expect(historico1.isAprovado(aluno1), true);
    Aluno aluno3 = Aluno('Fernanda', 2023);
    aluno3.id = 2;
    historico1.matricular(aluno3);
    historico1.notas[aluno3]?.addAll([3, 5, 7]);
    expect(historico1.media(aluno3), 5.0);
    expect(historico1.isAprovado(aluno3), false);
  });
}

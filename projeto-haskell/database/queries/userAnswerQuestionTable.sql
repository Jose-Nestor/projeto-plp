/*
    A existencia dessa tabela é discutível, pois
    timeSpent e markedAnswer são atributos que podem ser
    calculados durante a execução e este cálculo poderia ser
    colocado no atributo 'score', além disso, poderia ter uma
    coluna timeSpent em userAnswer, para indicar o tempo total gasto
 */
CREATE TABLE IF NOT EXISTS user_answer_question (
    user_answer_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    timeSpent INTEGER NOT NULL,
    markedAnswer INTEGER NOT NULL,
    FOREIGN KEY (user_answer_id) REFERENCES user_answer (id),
    FOREIGN KEY (question_id) REFERENCES question (id)
);
module CRUDQuiz where
import Controller.QuizController
    ( deleteQuiz, updateQuiz, getAllQuizzes, getMyQuizzes, addQuiz )
import Entities.Quiz ( getTopic, getName, Quiz(Quiz, quiz_id, user_id) )
import System.Console.ANSI ( clearScreen )
import Data.Char ()
import System.Exit ( exitSuccess )
import System.IO ()
import Utils.Util ( getLineWithMessage, printBorderTerminal, getAlterLine )
import CRUDQuestion
import Data.Maybe (fromMaybe)
import MainResolveQuiz (mainResolve)

-- menu para cadastrar quizzes
menuQuiz:: Int -> String -> IO()
menuQuiz 1 user_id = do
    printBorderTerminal
    nameQuiz <- getLineWithMessage "Nome do Quiz> "
    topicQuiz <- getLineWithMessage "Tópico do Quiz> "
    addQuiz nameQuiz topicQuiz user_id
    printBorderTerminal
    resp <- getLineWithMessage "Quiz cadastrado! Pressione enter para voltar..."
    mainQuiz user_id

-- menu para listar os quizzes do usuário
menuQuiz 2 user_id = do
    clearScreen
    printBorderTerminal
    quizzes <- getMyQuizzes user_id
    putStrLn $ printQuiz quizzes 1
    printBorderTerminal
    cod <- getLineWithMessage "Selecione um quiz pelo número para editar, enter para sair> "
    if cod == "" then
        mainQuiz user_id
    else
        menuSelectedQuiz user_id (quizzes!!(read cod-1))
    resp <- getLineWithMessage "Pressione enter para voltar..."
    mainQuiz user_id

-- menu para listar todos os quizzes
menuQuiz 3 user_id = do
    printBorderTerminal
    quizzes <- getAllQuizzes
    putStrLn $ printQuiz quizzes 1
    printBorderTerminal
    resp <- getLineWithMessage "Pressione enter para voltar..."
    mainQuiz user_id

menuQuiz 4 user_id = do
    printBorderTerminal
    quizzes <- getAllQuizzes
    putStrLn $ printQuiz quizzes 1
    printBorderTerminal
    resp <- getLineWithMessage "Escolha um quiz pelo número> "
    if read resp <= length quizzes && read resp > 0 then
        mainResolve user_id (quizzes!!(read resp - 1))
        >> getLineWithMessage "Enter para voltar ao menu principal..." >>
        mainQuiz user_id
    else do
        getLineWithMessage "Quiz não encontrado! Pressione Enter para voltar ao menu principal..."
        mainQuiz user_id


menuQuiz cod user_id = do
    printBorderTerminal
    resp <- getLineWithMessage "Opção de menu não encontrada. Pressione enter para voltar..."
    mainQuiz user_id

-- menu para editar o quiz
menuSelectedQuiz:: String -> Quiz -> IO()
menuSelectedQuiz user_id quiz = do
    clearScreen
    putStrLn $ show quiz
    printBorderTerminal
    putStrLn "1 - Ver questões"
    putStrLn "2 - Alterar quiz"
    putStrLn "0 - Deletar quiz"
    printBorderTerminal
    resp <- getLineWithMessage "Selecione uma opção ou pressione enter para voltar> "
    if resp /= "" then
        if read resp == 1 then
            mainQuestion (quiz_id quiz)
        else if read resp == 2 then do
            putStrLn "Alterando quiz... Se não quiser alterar um atributo apenas dê enter"
            name <- getAlterLine "Nome> " (getName quiz)
            topic <- getAlterLine "Tópico> " (getTopic quiz)
            let nameEdited = fromMaybe "Not Found" name
            let topicEdited = fromMaybe "Not Found" topic
            updateQuiz $ Quiz (quiz_id quiz) nameEdited topicEdited user_id
            putStrLn $ if (nameEdited == getName quiz) &&
                (topicEdited == getTopic quiz) then "Nada a alterar..." else "Quiz alterado!"
        else if read resp == 0 then do
            deleteQuiz $ quiz_id quiz
            putStrLn "Quiz deletado com sucesso!"
        else
            putStrLn "Opção não listada"
    else
        menuQuiz 2 user_id

printQuiz:: [Quiz] -> Int -> String
printQuiz [] count = ""
printQuiz quizzes count = show count ++ ", "++
                            show (head quizzes) ++ "\n" ++
                            printQuiz (tail quizzes) (count+1)

-- Função para executar o CRUD de quizes
mainQuiz:: String -> IO()
mainQuiz user_id = do
    clearScreen
    printBorderTerminal
    putStrLn "1 - Cadastrar Quiz"
    putStrLn "2 - Meus Quizzes"
    putStrLn "3 - Listar Quizzes"
    putStrLn "4 - Resolver Quizzes"
    putStrLn "99 - Sair"
    printBorderTerminal
    resp <- getLineWithMessage "Opção> "
    clearScreen
    if read resp /= 99 then
        menuQuiz (read resp) user_id
    else
        exitSuccess
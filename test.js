const SELECT = "SELECT"
const MULTISELECT = "MULTISELECT"

class Answer {
    constructor(text, isCorrect) {
        this.id = Math.random()
        this.text = text
        this.isCorrect = isCorrect
    }
}

class Question {
    constructor(text, type) {
        this.id = Math.random()
        this.type = type
        this.text = text
        this.answers = {}
    }

    addAnswer(text, isCorrect) {
        const newAnswer = new Answer(text, isCorrect)
        this.answers = newAnswer
    }

    removeAnswer(id) {
        delete this.answers[id]
    }
}

class Test {
    constructor(name) {
        this.id = Math.random()
        this.name = name
        this.questions = {}
    }

    addQuestion(text, type) {
        const newQuestion = new Question(text, type)
        this.questions[newQuestion.id] = newQuestion
    }

    removeQuestion(id) {
        delete this.questions[id]
    }
}

class TestManager {
    constructor() {
        this.tests = {};
    }

    createTest(name) {
        const newTest = new Test(name)
        this.tests[newTest.id] = newTest
    }

    removeTest(id) {
        delete this.tests[id]
    }
}

class SimpleExam {
    constructor(test) {
        this.isStarted = false
        this.questionIds = Object.keys(test.questions)
        this.questionAnswers = {}
        this.countQuestions = test.questions.length
        this.currentQuestionId = 0
        this.test = test
    }

    getNextQuestion() {
        if (!this.isStarted) {
            this.questionAnswers = {}
            this.isStarted = true
            return this.test.questions[this.currentQuestionId]
        }

        if (this.currentQuestionId < this.countQuestions) {
            this.currentQuestionId++
            return this.test.questions[this.currentQuestionId]
        }

        this.isStarted = false
        this.currentQuestionId = 0
    }

    setQuestionAnswer(questionId, answers) {
        this.questionAnswers[questionId] = [...answers]
    }

    checkExam() {
        const result = {}
        this.questionIds.forEach(id => {
            const correctAnswers = this.test.questions[id].answers.filter(answer => answer.isCorrect)
            const userAnswers = this.questionAnswers[id]
            result[id] = {
                correctAnswers,
                userAnswers,
            }
        })

        return result
    }
}
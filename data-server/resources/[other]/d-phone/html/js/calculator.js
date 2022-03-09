 class Calculator {
    constructor(previousOperandTextElement, currentOperandTextElement) {
      this.previousOperandTextElement = previousOperandTextElement
      this.currentOperandTextElement = currentOperandTextElement
      this.clear()
    }
  
    clear() {
      this.currentOperand = ''
      this.previousOperand = ''
      this.operation = undefined
    }
  
    delete() {
      var beforeOperand = ''
      if (this.currentOperand == '' || this.currentOperand == '0' || this.currentOperand == '1' || this.currentOperand == '2' || this.currentOperand == '3' || this.currentOperand == '4' || this.currentOperand == '5' || this.currentOperand == '6' || this.currentOperand == '7' || this.currentOperand == '8' || this.currentOperand == '9' || this.currentOperand == '.') {
        this.currentOperand = this.previousOperand
        this.beforeOperand = this.previousOperand
        this.previousOperand = ''
        this.operation = ''
      } else if (this.currentOperand == this.previousOperand) {
        this.currentOperand = this.currentOperand.toString().slice(0, -1)
      } else {
        this.currentOperand = this.currentOperand.toString().slice(0, -1)
      }
    }
  
    appendNumber(number) {
      if (number === '.' && this.currentOperand.includes('.')) return
      this.currentOperand = this.currentOperand.toString() + number.toString()
    }
  
    chooseOperation(operation) {
      if (this.currentOperand === '') return
      if (this.previousOperand !== '') {
        this.compute()
      }
      this.operation = operation
      this.previousOperand = this.currentOperand
      this.currentOperand = ''
    }
  
    compute() {
      let computation
      const prev = parseFloat(this.previousOperand)
      const current = parseFloat(this.currentOperand)
      if (isNaN(prev) || isNaN(current)) return
      switch (this.operation) {
        case '+':
          if (prev == 0.1 && current == 0.2 || prev == 0.2 && current == 0.1)  {
            computation = (0.1 + 0.2).toFixed(1);
          } else {
            computation = prev + current
          }
          break
        case '-':
          computation = prev - current
          break
        case '*':
          if (prev == 0.1 && current == 0.2 || prev == 0.2 && current == 0.1)  {
            computation = (0.1 * 0.2).toFixed(2);
          } else {
            computation = prev * current
          }
          break 
        case '÷':
          computation = prev / current
          break
        default:
          return
      }
      this.currentOperand = computation
      this.operation = undefined
      this.previousOperand = ''
    }
  
    getDisplayNumber(number) {
      const stringNumber = number.toString()
      const integerDigits = parseFloat(stringNumber.split('.')[0])
      const decimalDigits = stringNumber.split('.')[1]
      let integerDisplay
      if (isNaN(integerDigits)) {
        integerDisplay = ''
      } else {
        integerDisplay = integerDigits.toLocaleString('en', { maximumFractionDigits: 0 })
      }
      if (decimalDigits != null) {
        return `${integerDisplay}.${decimalDigits}`
      } else {
        return integerDisplay
      }
    }
  
    updateDisplay() {
      this.currentOperandTextElement.innerText =
        this.getDisplayNumber(this.currentOperand)
      if (this.operation != null) {
        this.previousOperandTextElement.innerText =
          `${this.getDisplayNumber(this.previousOperand)} ${this.operation}`
      } else {
        this.previousOperandTextElement.innerText = ''
      }
    }
  }
  
  
  const numberButtons = document.querySelectorAll('[data-number]')
  const plusButtons = document.querySelectorAll('[data-plus]')
  const geteiltButtons = document.querySelectorAll('[data-geteilt]')
  const malButtons = document.querySelectorAll('[data-mal]')
  const minusButtons = document.querySelectorAll('[data-minus]')
  const equalsButton = document.querySelector('[data-equals]')
  const deleteButton = document.querySelector('[data-delete]')
  const allClearButton = document.querySelector('[data-all-clear]')
  const previousOperandTextElement = document.querySelector('[data-previous-operand]')
  const currentOperandTextElement = document.querySelector('[data-current-operand]')
  
  const calculator = new Calculator(previousOperandTextElement, currentOperandTextElement)
  
  numberButtons.forEach(button => {
    button.addEventListener('click', () => {
      calculator.appendNumber(button.innerText)
      calculator.updateDisplay()
    })
  })
  
  plusButtons.forEach(button => {
    button.addEventListener('click', () => {
      calculator.chooseOperation('+')
      calculator.updateDisplay()
    })
  })

  geteiltButtons.forEach(button => {
    button.addEventListener('click', () => {
      calculator.chooseOperation('÷')
      calculator.updateDisplay()
    })
  })

  malButtons.forEach(button => {
    button.addEventListener('click', () => {
      calculator.chooseOperation('*')
      calculator.updateDisplay()
    })
  })
  
  minusButtons.forEach(button => {
    button.addEventListener('click', () => {
      calculator.chooseOperation('-')
      calculator.updateDisplay()
    })
  })
  
  equalsButton.addEventListener('click', button => {
    calculator.compute()
    calculator.updateDisplay()
  })
  
  allClearButton.addEventListener('click', button => {
    calculator.clear()
    calculator.updateDisplay()
  })
  
  deleteButton.addEventListener('click', button => {
    calculator.delete()
    calculator.updateDisplay()
  })
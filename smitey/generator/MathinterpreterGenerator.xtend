/*
 * generated by Xtext 2.21.0
 */
package smitey.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import smitey.mathinterpreter.MathExp
import javax.swing.JOptionPane
import smitey.mathinterpreter.Primary
import smitey.mathinterpreter.Div
import smitey.mathinterpreter.Add
import smitey.mathinterpreter.Sub
import smitey.mathinterpreter.Mul
import smitey.mathinterpreter.Exp
import smitey.mathinterpreter.Num
import smitey.mathinterpreter.Parenthesis

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MathinterpreterGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val math = resource.allContents.filter(MathExp).next
		val result = math.compute
		System.out.println("Math expression = "+math.display)
		// For +1 score, replace with hovering, see Bettini Chapter 8
		JOptionPane.showMessageDialog(null, "result = "+result,"Math Language", JOptionPane.INFORMATION_MESSAGE)
	}
	
	def int compute(MathExp math) { 
		math.exp.computePrim
	}
	
	def dispatch int computePrim(Exp exp) {
		exp.computePrim
	}
	
	def dispatch int computePrim(Parenthesis parant){
		return computePrim(parant.getExp())
	}

	def dispatch int computePrim(Num num){
		return num.getValue()
	}
	
	def dispatch int computePrim(Add add){
		return add.left.computePrim+add.right.computePrim
	}
	
	def dispatch int computePrim(Sub sub){
		return sub.left.computePrim-sub.right.computePrim
	}
	
	def dispatch int computePrim(Mul mul){
		return mul.left.computePrim*mul.right.computePrim
	}
	
	def dispatch int computePrim(Div div){
		return div.left.computePrim/div.right.computePrim
	}

	def CharSequence display(MathExp math) '''Math[�math.exp.displayExp�]'''
	def CharSequence displayExp(Exp exp) '''Exp[�exp.displayOp�]'''
	def dispatch String displayOp(Add op) {'''(�op.left.displayOp�+�op.right.displayOp�)'''}
	def dispatch String displayOp(Sub op) {'''(�op.left.displayOp�-�op.right.displayOp�)'''}
	def dispatch String displayOp(Mul op) {'''(�op.left.displayOp�*�op.right.displayOp�)'''}
	def dispatch String displayOp(Div op) {'''(�op.left.displayOp�/�op.right.displayOp�)'''}
	def dispatch String displayOp(Parenthesis op) {'''(�op.exp�)'''}
	def dispatch String displayOp(Num op) {'''�op.value�'''}
	def CharSequence displayFactor(Primary primary) { "?" }
}
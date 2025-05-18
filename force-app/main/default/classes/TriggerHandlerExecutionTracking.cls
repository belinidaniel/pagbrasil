/**
 * @description       : 
 * @author            : Hersilio Belini de Oliveira
 * @group             : 
 * @last modified on  : 2024-10-23
 * @last modified by  : Hersilio Belini de Oliveira
**/
public without sharing class TriggerHandlerExecutionTracking {

	private List<TriggerHandlerDependency> dependenciesExecution;

	public class TriggerHandlerExecutionTrackingException extends Exception {}

	public TriggerHandlerExecutionTracking(){

		this.dependenciesExecution = new List<TriggerHandlerDependency>();
	}

	public void appendExecution( TriggerHandlerDependency dependency ){

		this.dependenciesExecution.add( dependency );
	}

	public TriggerHandlerDependency executionOrder( Integer ordering ){

		if ( this.dependenciesExecution.size() <= ordering )
			throw new TriggerHandlerExecutionTrackingException('Has no dependency execution for ordering and index: ' + ordering + '. Executions: '+ this.dependenciesExecution );

		return this.dependenciesExecution.get( ordering );
	}
}
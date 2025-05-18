/**
 * @description       :
 * @author            : Hersilio Belini de Oliveira
 * @group             :
 * @last modified on  : 2024-10-24
 * @last modified by  : Hersilio Belini de Oliveira
**/
public virtual without sharing class TriggerHandler {

    // static map of handlername, times run() was invoked
    private static Map<String, LoopCount> loopCountMap;
    private static Set<String> bypassedHandlers;

    // static initialization
    static {
        loopCountMap = new Map<String, LoopCount>();
        bypassedHandlers = new Set<String>();
    }

    private TriggerHandlerExecutionTracking executionTracking;

    // the current context of the trigger, overridable in tests
    @TestVisible
    protected TriggerContext context;

    // the current context of the trigger, overridable in tests
    @TestVisible
    private Boolean isTriggerExecuting;

    protected Filter filter;

    // constructor
    public TriggerHandler() {
        this.setTriggerContext();
        this.setExecutionTracking();
        this.filter = new Filter();
    }


    // main method that will be called during execution
    public void run() {

        if (!validateRun()) return;

        addToLoopCount();
        // dispatch to the correct handler method
        if (this.context == TriggerContext.BEFORE_INSERT) {

            this.validateBeforeInsert();
            this.beforeInsert();

        }   else if (this.context == TriggerContext.BEFORE_UPDATE) {

            this.validateBeforeUpdate();
            this.beforeUpdate();

        } else if (this.context == TriggerContext.BEFORE_DELETE) {

            this.beforeDelete();

        } else if (this.context == TriggerContext.AFTER_INSERT) {

            this.afterInsert();

        } else if (this.context == TriggerContext.AFTER_UPDATE) {

            this.afterUpdate();

        } else if (this.context == TriggerContext.AFTER_DELETE) {

            this.afterDelete();

        }   else if (this.context == TriggerContext.AFTER_UNDELETE) {

            this.afterUndelete();

        }

    }

    public TriggerHandlerExecutionTracking getExecutionTracking ( ) {

        return this.executionTracking;
    }

    public Integer getLoopCount() {

        String handlerName = getHandlerName();

        if (!TriggerHandler.loopCountMap.containsKey(handlerName)) return 0;

        return TriggerHandler.loopCountMap.get(handlerName).count;

    }


    public void setMaxLoopCount(Integer max) {
        String handlerName = getHandlerName();
        if (!TriggerHandler.loopCountMap.containsKey(handlerName)) {
            TriggerHandler.loopCountMap.put(handlerName, new LoopCount(max));
        } else {
            TriggerHandler.loopCountMap.get(handlerName).setMax(max);
        }
    }

    public void clearMaxLoopCount() {
        this.setMaxLoopCount(-1);
    }


    //***************************************
    //* public static methods
    //***************************************/
    public static void bypass(String handlerName) {
        TriggerHandler.bypassedHandlers.add(handlerName);
    }

    public static void clearBypass(String handlerName) {
        TriggerHandler.bypassedHandlers.remove(handlerName);
    }

    public static Boolean isBypassed(String handlerName) {
        return TriggerHandler.bypassedHandlers.contains(handlerName);
    }

    public static void clearAllBypasses() {
        TriggerHandler.bypassedHandlers.clear();
    }



    @TestVisible
    private void setTriggerContext() {
        this.setTriggerContext(null, false);
    }

    @TestVisible
    private void setExecutionTracking() {
        this.executionTracking = new TriggerHandlerExecutionTracking();
    }

    @TestVisible
    private void setTriggerContext(String ctx, Boolean testMode) {

        this.isTriggerExecuting = true;

        if (!Trigger.isExecuting && !testMode) {
            this.isTriggerExecuting = false;
            return;
        }

        if ( isOperationTypeOrContextRunningOperationType ( TriggerOperation.BEFORE_INSERT, ctx , 'before insert') ) {

            this.context = TriggerContext.BEFORE_INSERT;

        } else if ( isOperationTypeOrContextRunningOperationType ( TriggerOperation.BEFORE_UPDATE, ctx, 'before update') ) {

            this.context = TriggerContext.BEFORE_UPDATE;

        } else if ( isOperationTypeOrContextRunningOperationType ( TriggerOperation.BEFORE_DELETE, ctx , 'before delete') ) {

            this.context = TriggerContext.BEFORE_DELETE;

        } else if ( isOperationTypeOrContextRunningOperationType ( TriggerOperation.AFTER_INSERT, ctx, 'after insert')) {

            this.context = TriggerContext.AFTER_INSERT;

        } else if ( isOperationTypeOrContextRunningOperationType ( TriggerOperation.AFTER_UPDATE, ctx, 'after update')) {

            this.context = TriggerContext.AFTER_UPDATE;

        } else if ( isOperationTypeOrContextRunningOperationType ( TriggerOperation.AFTER_DELETE, ctx, 'after delete')) {

            this.context = TriggerContext.AFTER_DELETE;

        } else if ( isOperationTypeOrContextRunningOperationType ( TriggerOperation.AFTER_UNDELETE, ctx, 'after undelete')) {

            this.context = TriggerContext.AFTER_UNDELETE;

        }
    }

    private Boolean isOperationTypeOrContextRunningOperationType ( TriggerOperation operationType, String ctx , String operationTypeName ) {
        return   isOperationType (operationType) || isContextRunningOperationType(ctx, operationTypeName);
    }

    private Boolean isOperationType ( TriggerOperation operationType ) {
        return   Trigger.isExecuting && Trigger.operationType == operationType;
    }

    private Boolean isContextRunningOperationType (String ctx , String operationType) {
        return ctx != null && ctx == operationType;
    }

    // increment the loop count
    @TestVisible
    private void addToLoopCount() {
        String handlerName = getHandlerName();

        if (TriggerHandler.loopCountMap.containsKey(handlerName)) {
            Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();
            if (exceeded) {
                Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
                throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
            }
        }

    }

    // make sure this trigger should continue to run
    @TestVisible
    private Boolean validateRun() {

        if (!this.isTriggerExecuting || this.context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }

        if (TriggerHandler.bypassedHandlers.contains(getHandlerName())) return false;

        return true;
    }

    @TestVisible
    private String getHandlerName() {
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }

    public Filter filtering() {
        return this.filter;
    }
    // context-specific methods for override
    @TestVisible
    protected virtual void beforeInsert() {
        LoggerBase.log ('beforeInsert');
    }

    @TestVisible
    protected virtual void beforeUpdate() {
        LoggerBase.log ('beforeUpdate');
    }

    @TestVisible
    protected virtual void beforeDelete() {
        LoggerBase.log ('beforeDelete');
    }

    @TestVisible
    protected virtual void afterInsert() {
        LoggerBase.log ('afterInsert');
    }

    @TestVisible
    protected virtual void afterUpdate() {
        LoggerBase.log ('afterUpdate');
    }

    @TestVisible
    protected virtual void afterDelete() {
        LoggerBase.log ('afterDelete');
    }

    @TestVisible
    protected virtual void afterUndelete() {
        LoggerBase.log ('afterUndelete');
    }


    @TestVisible
    protected virtual void validateBeforeInsert() {
        LoggerBase.log ('validateBeforeInsert'); // prevent EmptyStatementBlock rule
    }

    @TestVisible
    protected virtual void validateBeforeUpdate() {
        LoggerBase.log ('validateBeforeUpdate'); // prevent EmptyStatementBlock rule
    }

    // inner class for managing the loop count per handler
    @TestVisible
    private class LoopCount {

        private Integer max;
        private Integer count;

        public LoopCount() {
            this.max = 5;
            this.count = 0;
        }

        public LoopCount(Integer max) {
            this();
            this.max = max;
        }

        public Boolean increment() {
            this.count++;
            return this.exceeded();
        }

        public Boolean exceeded() {
            if (this.max < 0) return false;
            if (this.count > this.max) {
                return true;
            }
            return false;
        }
        public Integer getMax() {
            return this.max;
        }
        public Integer getCount() {
            return this.count;
        }
        public void setMax(Integer max) {
            this.max = max;
        }
    }

    // possible trigger contexts
    @TestVisible
    private enum TriggerContext {
        BEFORE_INSERT,
        BEFORE_UPDATE,
        BEFORE_DELETE,
        AFTER_INSERT,
        AFTER_UPDATE,
        AFTER_DELETE,
        AFTER_UNDELETE
    }

    // exception class
    public class TriggerHandlerException extends Exception {}
}
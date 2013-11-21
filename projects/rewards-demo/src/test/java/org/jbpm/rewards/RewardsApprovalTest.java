package org.jbpm.rewards;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jbpm.process.instance.impl.demo.SystemOutWorkItemHandler;
import org.jbpm.test.JbpmJUnitBaseTestCase;
import org.junit.Before;
import org.junit.Test;
import org.kie.api.io.ResourceType;
import org.kie.api.runtime.KieSession;
import org.kie.api.runtime.manager.RuntimeEngine;
import org.kie.api.runtime.process.ProcessInstance;
import org.kie.api.task.TaskService;
import org.kie.api.task.model.TaskSummary;
import org.kie.internal.runtime.manager.context.ProcessInstanceIdContext;

/**
 * This is a sample file to launch a process.
 */
public class RewardsApprovalTest extends JbpmJUnitBaseTestCase {

	private static RuntimeEngine runtime;
	private static TaskService taskService;
	private static Map<String, Object> params;
	
	public RewardsApprovalTest() {
		super(true, false);
	}

	@Before
	@Override
	public void setUp() throws Exception {
		super.setUp();
	
        // initialize process parameters.
		params = new HashMap<String, Object>();
        params.put("employee", "erics");
        params.put("reason", "Amazing demos for JBoss World!");

        // create runtime
		Map<String, ResourceType> resources = new HashMap<String, ResourceType>();
		resources.put("rewardsapproval.bpmn2", ResourceType.BPMN2);
		createRuntimeManager(Strategy.SINGLETON, resources);
		runtime = getRuntimeEngine(ProcessInstanceIdContext.get());

		// create task service
		taskService = runtime.getTaskService();
	}
	
	@Test
	public void rewardApprovedTest() {
		KieSession ksession = runtime.getKieSession();
		// register work items
        ksession.getWorkItemManager().registerWorkItemHandler("Log", new SystemOutWorkItemHandler());
        ksession.getWorkItemManager().registerWorkItemHandler("Email", new SystemOutWorkItemHandler());
		
        // start process.
		ProcessInstance processInstance = ksession.startProcess("org.jbpm.approval.rewards", params);
		
		// execute task by Mary from HR.
		List<TaskSummary> list = taskService.getTasksAssignedAsPotentialOwner("mary", "en-UK");
		TaskSummary task = list.get(0);
		taskService.claim(task.getId(), "mary");
		taskService.start(task.getId(), "mary");
		
		Map<String, Object> taskParams = new HashMap<String, Object>();
		taskParams.put("Explanation", "Great work");
		taskParams.put("Outcome", "Approved");
		taskService.complete(task.getId(), "mary", taskParams);

		// test for completion and in correct end node.
		assertProcessInstanceCompleted(processInstance.getId(), ksession);
		assertNodeTriggered(processInstance.getId(), "End Approved");
		ksession.dispose();
	}
	
	@Test
	public void rewardRejectedTest() {
		KieSession ksession = runtime.getKieSession();
		// register work items
        ksession.getWorkItemManager().registerWorkItemHandler("Log", new SystemOutWorkItemHandler());
        ksession.getWorkItemManager().registerWorkItemHandler("Email", new SystemOutWorkItemHandler());
		
		ProcessInstance processInstance = ksession.startProcess("org.jbpm.approval.rewards", params);

		// execute task by John from HR.
		List<TaskSummary> list = taskService.getTasksAssignedAsPotentialOwner("john", "en-UK");
		TaskSummary task = list.get(0);
		taskService.claim(task.getId(), "john");
		taskService.start(task.getId(), "john");
		
		Map<String, Object> taskParams = new HashMap<String, Object>();
		taskParams.put("Explanation", "Too complicated for me");
		taskParams.put("Outcome", "Rejected");
		// add results of task.
		taskService.complete(task.getId(), "john", taskParams);
		
		// test for completion and in correct end node.
		assertProcessInstanceCompleted(processInstance.getId(), ksession);
		assertNodeTriggered(processInstance.getId(), "End Rejected");
		ksession.dispose();
	}
	
}
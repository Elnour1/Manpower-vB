const SystemSettings = {
  COMPANY_BASELINE: 20,
  DAILY_OUTSOURCED_COST: 150
};

function calculateRequiredWorkers(machineEntries) {
  return machineEntries.reduce((sum, entry) => {
    if (entry.status === 'Stopped' || entry.status === 'Maintenance') {
      return sum;
    }
    const workers = entry.manualOverride !== null && entry.manualOverride !== undefined
      ? Number(entry.manualOverride)
      : Number(entry.standardWorkers || 0);
    
    return sum + workers;
  }, 0);
}

function calculateExternalRequirement(requiredWorkers, companyBaseline) {
  const externalNeeded = requiredWorkers - companyBaseline;
  return Math.max(0, externalNeeded);
}

function calculateLaborUtilization(actualWorkers, requiredWorkers) {
  if (!requiredWorkers || requiredWorkers === 0) {
    return { percentage: 100, trafficLight: 'GREEN' };
  }

  const utilization = Math.round((actualWorkers / requiredWorkers) * 100);

  let trafficLight = 'GREEN';
  if (utilization < 85) {
    trafficLight = 'RED';
  } else if (utilization < 95 || utilization > 105) {
    trafficLight = 'YELLOW';
  }

  return { percentage: utilization, trafficLight };
}

function calculateLaborCostAndSavings(contractedExternal, actualExternal, dailyCostPerWorker) {
  const currentCost = actualExternal * dailyCostPerWorker;
  const reductionInWorkers = Math.max(0, contractedExternal - actualExternal);
  const dailyRealizedSaving = reductionInWorkers * dailyCostPerWorker;

  return {
    dailyCost: currentCost,
    workersSaved: reductionInWorkers,
    dailyRealizedSaving: dailyRealizedSaving,
    monthlyEstimatedSaving: dailyRealizedSaving * 26
  };
}

function validateWorkforceAllocation(companyPresent, externalPresent, sumMachineActualWorkers) {
  const totalPresent = Number(companyPresent) + Number(externalPresent);
  const isValid = totalPresent === Number(sumMachineActualWorkers);

  return {
    isValid,
    totalPresent,
    sumMachineActualWorkers,
    message: isValid 
      ? "Workforce matches machine allocation perfectly." 
      : `Mismatch detected: Total Present (${totalPresent}) !== Machine Allocation (${sumMachineActualWorkers}).`
  };
}

module.exports = {
  calculateRequiredWorkers,
  calculateExternalRequirement,
  calculateLaborUtilization,
  calculateLaborCostAndSavings,
  validateWorkforceAllocation
};

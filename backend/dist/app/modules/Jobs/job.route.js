"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.jobRoutes = void 0;
const express_1 = __importDefault(require("express"));
const job_controller_1 = require("./job.controller");
const router = express_1.default.Router();
router.post('/', job_controller_1.JobController.createJob);
router.get('/', job_controller_1.JobController.getAllJobs);
router.get('/:jobId', job_controller_1.JobController.getSingleJob);
router.patch('/:jobId', job_controller_1.JobController.updateJob);
router.delete('/:jobId', job_controller_1.JobController.deleteJob);
exports.jobRoutes = router;

"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.JobServices = void 0;
const job_model_1 = require("./job.model");
const createJobInToDB = (payload) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield job_model_1.Job.create(payload);
    return result;
});
const getAllJobsFromDB = () => __awaiter(void 0, void 0, void 0, function* () {
    return yield job_model_1.Job.find().exec();
});
// Get single job
const getSingleJobFromDB = (id) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield job_model_1.Job.findById(id).exec();
    return result;
});
// Update job
const updateJobInDB = (jobId, payload) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield job_model_1.Job.findByIdAndUpdate(jobId, payload, { new: true }).exec();
    return result;
});
// Delete job
const deleteJobFromDB = (id) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield job_model_1.Job.findByIdAndDelete(id).exec();
    return result;
});
exports.JobServices = {
    createJobInToDB,
    getAllJobsFromDB,
    getSingleJobFromDB,
    updateJobInDB,
    deleteJobFromDB,
};

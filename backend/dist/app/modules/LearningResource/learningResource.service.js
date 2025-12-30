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
exports.LearningResourceServices = void 0;
const learningResource_model_1 = require("./learningResource.model");
const createLearningResource = (payload) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield learningResource_model_1.LearningResource.create(payload);
    return result;
});
const getAllLearningResources = () => __awaiter(void 0, void 0, void 0, function* () {
    return yield learningResource_model_1.LearningResource.find().exec();
});
// Get single learning resource
const getSingleLearningResource = (id) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield learningResource_model_1.LearningResource.findById(id).exec();
    return result;
});
// Update learning resource
const updateLearningResource = (resourceId, payload) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield learningResource_model_1.LearningResource.findByIdAndUpdate(resourceId, payload, { new: true }).exec();
    return result;
});
// Delete learning resource
const deleteLearningResource = (id) => __awaiter(void 0, void 0, void 0, function* () {
    const result = yield learningResource_model_1.LearningResource.findByIdAndDelete(id).exec();
    return result;
});
exports.LearningResourceServices = {
    createLearningResource,
    getAllLearningResources,
    getSingleLearningResource,
    updateLearningResource,
    deleteLearningResource,
};

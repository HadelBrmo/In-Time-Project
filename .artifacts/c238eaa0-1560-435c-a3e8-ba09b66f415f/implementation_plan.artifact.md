# Implementation Plan - Upload Complaint Documents

Add functionality to upload images and files when submitting a complaint.

## User Review Required

- The UI will include a dashed border area with "Image" and "File" buttons.
- Multiple files/images can be selected.
- Document upload will happen immediately after complaint submission.

## Proposed Changes

### Core

#### [MODIFY] [app_strings.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/core/constants/app_strings.dart)
- Add `uploadComplaintDocumentsUrl(int id)` static method.

### Complaints Feature

#### [MODIFY] [i_complaint_repository.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/complaints/domain/repositories/i_complaint_repository.dart)
- Add `uploadComplaintDocuments(int complaintId, List<String> filePaths)` method.

#### [NEW] [upload_complaint_documents_usecase.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/complaints/domain/usecases/upload_complaint_documents_usecase.dart)
- Create use case for uploading documents.

#### [MODIFY] [complaint_remote_data_source.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/complaints/data/datasources/complaint_remote_data_source.dart)
- Add `uploadComplaintDocuments` implementation using `Dio` and `FormData`.

#### [MODIFY] [complaint_repository_impl.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/complaints/data/repositories/complaint_repository_impl.dart)
- Implement `uploadComplaintDocuments`.

#### [MODIFY] [complaint_event.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/complaints/presentation/bloc/complaint_event.dart)
- Update `SubmitComplaintEvent` to include a list of document file paths.

#### [MODIFY] [complaint_bloc.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/complaints/presentation/bloc/complaint_bloc.dart)
- Update `SubmitComplaintEvent` handler to call `UploadComplaintDocumentsUseCase` if file paths are provided.

#### [MODIFY] [submit_complaint_page.dart](file:///C:/Users/User/StudioProjects/In-Time-Project/lib/features/complaints/presentation/pages/submit_complaint_page.dart)
- Implement UI for document selection (Images and Files).
- Use `dotted_border` for the upload section.
- Handle state for selected files.

## Verification Plan

### Manual Verification
- Test submitting a complaint without documents.
- Test submitting a complaint with images only.
- Test submitting a complaint with files only.
- Test submitting a complaint with both images and files.
- Verify success dialog shows up and fields are cleared.

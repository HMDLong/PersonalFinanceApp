import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saving_app/data/local/model_repos/plan_transact/plan_transact_repo.dart';
import 'package:saving_app/data/models/plan_transaction.model.dart';
import 'package:saving_app/presentation/managers/plan_manager.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PlanTimelineTab extends StatefulWidget {
  const PlanTimelineTab({super.key});

  @override
  State<PlanTimelineTab> createState() => _PlanTimelineTabState();
}

class _PlanTimelineTabState extends State<PlanTimelineTab> {
  
  @override
  Widget build(BuildContext context) {
    var planTransacts = context.watch<PlanTransactJsonRepository>().getAll();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SfCalendar(
          showNavigationArrow: true,
          view: CalendarView.month,
          monthViewSettings: const MonthViewSettings(
            showAgenda: true,
            agendaItemHeight: 60.0,
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
          ),
          dataSource: PlanTransactionCalendarData(planTransacts),
          appointmentBuilder: (context, calendarAppointmentDetails) {
            final appointment = calendarAppointmentDetails.appointments.first as PlanTransaction;
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: switch(appointment.status) {
                      PaidStatus.late => Colors.red,
                      PaidStatus.upcoming => Colors.amber,
                      PaidStatus.paid => Colors.green,
                    },
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.title,
                            style: const TextStyle(
                              fontSize: 12
                            ),
                          ),
                          Text(
                            "${NumberFormat.decimalPattern().format(appointment.amount)} VND",
                            style: const TextStyle(
                              fontSize: 12
                            ),
                          ),
                        ],
                      )
                    ),
                    Expanded(
                      flex: 2,
                      child: Switch(
                        value: appointment.notificationId > 0, 
                        onChanged: (switchOn) {
                          context.read<PlanController>().setNotification(appointment.id, switchOn);
                        }
                      )
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlanTransactionCalendarData extends CalendarDataSource<PlanTransaction> {
  PlanTransactionCalendarData(List<PlanTransaction> transacts) {
    appointments = transacts;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].transactDate;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].transactDate;
  }

  @override
  String getSubject(int index) {
    return "${appointments![index].title}";
  }

  @override
  String? getNotes(int index) {
    return "${NumberFormat.decimalPattern().format(appointments![index].amount)} VND";
  }

  @override
  Color getColor(int index) {
    return switch((appointments![index] as PlanTransaction).status) {
      PaidStatus.late => Colors.red,
      PaidStatus.upcoming => Colors.amber,
      PaidStatus.paid => Colors.green,
    };
  }

  @override
  bool isAllDay(int index) => true;
}